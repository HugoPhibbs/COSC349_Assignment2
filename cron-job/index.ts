const cron = require('node-cron');
const mysql = require('mysql2/promise');
const dotenv = require('dotenv');

// Load env variables
dotenv.config();

const DB_HOST = (process.env.DB_HOST).replace(/:3306$/, ''); // Terraform attaches port to end, which needs to be removed

const pool = mysql.createPool({
    host: DB_HOST, // not totally sure why we don't use mysql! TODO Change
    user: "admin",
    password: "password",
    database: "event_calendar",
});

pool.getConnection((err, connection) => {
    if (err) {
        console.error("An error occurred while connecting to the database", err);
        throw err;
    }

    console.log("Connected to the database");
    connection.release();
})

async function deleteFinishedEvents() {
    try {
        // Fetch all events from the database
        const [rows] = await pool.query("SELECT eventId, endDate FROM EVENT");

        const events = rows as { eventId: number, endDate: string }[];

        const currentTime = new Date();

        const eventsToDelete = [];

        // Check each event's endDate and collect the IDs of events to be deleted
        events.forEach(event => {
            const { eventId, endDate } = event;
            const formattedEndDate = new Date(endDate);

            if (formattedEndDate <= currentTime) {
                eventsToDelete.push(eventId);
            }
        });

        const [dontDeleteResult] = await pool.query("SELECT eventId FROM RECURRING_EVENT_SUFFIX");
        const dontDeleteIds = (dontDeleteResult as { eventId: number }[]).map(row => row.eventId);

        // Remove events that have a matching ID in dontDeleteResult
        const filteredEventsToDelete = eventsToDelete.filter(eventId => !dontDeleteIds.includes(eventId));

        // Delete the remaining events from the database
        if (filteredEventsToDelete.length > 0) {
            await pool.query("DELETE FROM EVENT WHERE eventId IN (?)", [filteredEventsToDelete]);
        }


        const [recurringEvents] = await pool.query("SELECT recurringEventId, endDate FROM RECURRING_EVENT")


        const recurringEventsToDelete = (recurringEvents as { recurringEventId: number, endDate: string }[])
            .filter(recurringEvent => {
                const { recurringEventId, endDate } = recurringEvent;
                const formattedEndDate = new Date(endDate);
                return formattedEndDate <= currentTime;
            })
            .map(recurringEvent => recurringEvent.recurringEventId);
            

        // Delete the recurring events from the database
        if (recurringEventsToDelete.length > 0) {
            await pool.query("DELETE FROM RECURRING_EVENT WHERE recurringEventId IN (?)", [recurringEventsToDelete]);
        }

        const deleteCount = filteredEventsToDelete.length + recurringEventsToDelete.length;
        return deleteCount;
    } catch (err) {
        throw new Error("An error occurred while deleting the events: " + err);
    }
}

function startCronJob() {
    //every hour '0 * * * *'
    //every minute '* * * * *'
    //every second '* * * * * *'
    const task = cron.schedule('* * * * *', async () => {
        console.log("attempting...")
        try {
            const deletedCount = await deleteFinishedEvents();
            console.log(`${deletedCount} event(s) deleted`);
        } catch (error) {
            console.error('Error deleting events:', error);
        }
    });

    task.start();
}

console.log("Starting cron job...")
startCronJob()