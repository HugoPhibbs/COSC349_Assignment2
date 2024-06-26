import express from "express";
import {Pool} from "mysql2/promise";
import multer from "multer"; //for Form inputs
import {OkPacket} from "mysql2";
import bodyParser from "body-parser";
const pool: Pool = require("../helpers").pool; // For SQL

// Getting routers
const userRouter = require("./user-router").userRouter; // For user routes
const eventRouter = require("./event-router").eventRouter; // For event routes
const authRouter = require("./auth").authRouter; // For auth routes

// Create express app
const app = express();

// Add react app to public
// app.use(express.static("../react-app/build"));

const bcrypt = require("bcryptjs");

// Adding CORS(Cross Origin Resource Sharing) express
const cors = require("cors");
app.use(
    cors({
        origin: true,
        credentials: true,
    })
);

// For parsing JSON bodies
app.use(bodyParser.json());

// For parsing FORM inputs
// app.use(multer().none());  // TODO use this individually for each route that actually needs it

/**
 * Registers a new user.
 *
 * Put at the top of express file to skip auth
 *
 * Intended to be used with the 'create-account' button on the front end
 *
 * As such, this route provides restricted access to what can be inserted into the DB - e.g. no users with admin privileges can be created
 */
app.post("/register", async (req, res) => {
    try {
        const hashSaltPassword = bcrypt.hashSync(req.body.password, 10);
        await pool.query<OkPacket>(
            `INSERT INTO USER (firstName, lastName, isAdmin, email, password)
             VALUES (?, ?, ?, ?, ?)`,
            [
                req.body.firstName,
                req.body.lastName,
                0,
                req.body.email,
                hashSaltPassword,
            ]
        );
        res.send("User registered successfully");
    } catch (e) {
        console.log(e);
        res.status(500).send("An error occurred while registering the user");
    }
});

// Add in routers
app.use(authRouter);
app.use("/user", userRouter);
app.use("/event", eventRouter);

module.exports = {
    app: app,
    pool,
};
