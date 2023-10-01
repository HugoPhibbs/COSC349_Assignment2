import {User} from "./entities";

export {};

import mysql, {RowDataPacket} from "mysql2/promise";
import dotenv from "dotenv";

const createHttpError = require("http-errors");

// Load env variables
dotenv.config({path: __dirname + "/../.env"});

const DB_HOST = (process.env.DB_HOST).replace(/:3306$/, ''); // Terraform attaches port to end, which needs to be removed

const pool = mysql.createPool({
    host: DB_HOST, // not totally sure why we don't use mysql!
    user: "admin",
    password: "password",
    database: "event_calendar",
});

/**
 * Handles an api error
 *
 * @param err error thrown, may be a createHttpError or a mysql error
 * @param res express Response to send back to client
 * @param msg message to accompany the response
 */
function handleApiError(err: any, res, msg: string) {
    console.log(err);
    return res
        .status(err.status ? err.status : 500)
        .send(err.message ? err.message : msg);
}

/**
 * Checks if a with the given ID has permissions to change a resource
 *
 * If they are not an admin, their username(email) needs to match the provided id
 *
 * Throws a 403 if the user does not have permissions
 *
 * @param userRole role of the user to check permissions
 * @param userId id of the user to check permissions
 * @param username username of the user to check permissions
 * @param userId id of the user to check permissions
 */
async function checkUserPermissions(userRole, userId, username) {
    // If the user is not an admin, check if the auth username matches the user being assigned
    if (userRole !== "admin") {
        const results = await pool.query<User[]>(
            `SELECT *
             FROM USER
             WHERE email = ?
               AND userId = ?`,
            [username, userId]
        );
        if ((results as RowDataPacket[])[0].length === 0) {
            throw new createHttpError(403, "Forbidden");
        }
    }
    return;
}

module.exports = {
    pool,
    handleApiError,
    checkUserPermissions,
};
