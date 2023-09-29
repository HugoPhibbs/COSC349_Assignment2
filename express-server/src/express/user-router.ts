import { Pool, RowDataPacket } from "mysql2/promise";

import { ResultSetHeader } from "mysql2";
import { User } from "../entities";
import * as fs from "fs";
const path = require("path");

const { pool, handleApiError, checkUserPermissions } =
    require("../helpers") as {
        pool: Pool;
        handleApiError: any;
        checkUserPermissions: any;
    };
const express = require("express");
const userRouter = express.Router();

// Password encryption
const bcrypt = require("bcryptjs");

// // For only accepting jpg uploads
// const fileFilter = function (req, file, cb) {
//     if (file.mimetype !== "image/jpeg") {
//         return cb(new Error("Only JPEG files are allowed"));
//     }
//     cb(null, true);
// };


/**
 * Get all users
 */
userRouter.get("/", async (req, res) => {
    try {
        const includeAdmins = Boolean(req.query.includeAdmins);

        const [results] = await pool.query<User[]>(
            `SELECT *
             FROM USER
             WHERE isAdmin = ? OR isAdmin = 0`,
            [includeAdmins]
        );
        res.send(results);
    } catch (err) {
        return handleApiError(
            err,
            res,
            "An internal error occurred while getting the users"
        );
    }
});

/**
 * Creates a new user
 */
userRouter.post("/", async (req, res) => {
    try {
        const { firstName, lastName, isAdmin, email, password } = req.body;

        const passwordHashSalt = bcrypt.hashSync(password, 10);

        const [result] = await pool.query<ResultSetHeader>(
            "INSERT INTO USER (firstName, lastName, isAdmin, email, password) VALUES (?, ?, ?, ?, ?)",
            [firstName, lastName, isAdmin, email, passwordHashSalt]
        );
        const { insertId } = result;
        res.send({ userId: insertId });
    } catch (err) {
        if (err.code === "ER_DUP_ENTRY") {
            return res.status(409).send("User with email already exists");
        }
        return handleApiError(
            err,
            res,
            "An internal error occurred while creating a user"
        );
    }
});

/**
 * Get a user by ID
 */
userRouter.get("/:userId", async (req, res) => {
    try {
        const [results] = await pool.query<User[]>(
            `SELECT *
             FROM USER
             WHERE userId = ?`,
            [req.params.userId]
        );
        if (
            typeof results === "undefined" ||
            (results as RowDataPacket[]).length === 0
        ) {
            return res.status(404).send("User not found");
        } else {
            res.send(results[0]);
        }

        const foundUser = results[0];

        if (req.role !== "admin") {
            foundUser.password = "REDACTED";
        }
        return res.send(foundUser);
    } catch (err) {
        return handleApiError(
            res,
            err,
            "An internal error occurred while getting a user"
        );
    }
});

/**
 * Updates a user. Intended to be used by front end for updating a user's profile
 */
userRouter.patch("/:userId", async (req, res) => {
    try {
        const { firstName, lastName, email } = req.body;

        // console.log(`${req.role} ${req.params.userId} ${req.auth.user}`);

        //await checkUserPermissions(req.role, req.params.userId, req.auth.user);

        const result = await pool.query<ResultSetHeader>(
            "UPDATE USER SET firstName = ?, lastName = ?, email = ? WHERE userId = ?",
            [firstName, lastName, email, req.params.userId]
        );

        if (result[0].affectedRows === 0) {
            return res.status(404).send("User not found");
        }

        return res.status(204).send("User updated successfully");
    } catch (err) {
        return handleApiError(
            err,
            res,
            "An error occurred while updating the user"
        );
    }
});

/**
 * Delete a user by ID
 */
userRouter.delete("/:userId", async (req, res) => {
    try {
        const [results] = await pool.query<ResultSetHeader>(
            `DELETE FROM USER
             WHERE userId = ?`,
            [req.params.userId]
        );
        if (results.affectedRows === 0) {
            res.status(404).send("User not found");
        } else {
            res.sendStatus(204);
        }
    } catch (err) {
        return handleApiError(
            res,
            err,
            "An error occurred while deleting a user"
        );
    }
});

/*
 * Route to return all events for a given user
 *
 * Events can be filtered to come after a specific date-time
 */
userRouter.get("/:userId/events", async (req, res) => {
    const userId = req.params.userId;

    // await checkUserPermissions(req.role, userId, req.auth.user);

    const afterDateTime = req.query.afterDateTime as string;

    let query = `SELECT e.eventId, e.title, e.location, e.startDate, e.endDate, e.description
                 FROM EVENT e
                 INNER JOIN ATTENDANCE_RECORD ar ON e.eventId = ar.eventId
                 WHERE ar.userId = ?`;
    let values = [userId];

    if (afterDateTime) {
        query += ` AND e.startDate >= ?`;
        values.push(afterDateTime);
    }

    try {
        const [results] = await pool.query<[]>(query, values);

        // Check if the user is assigned to 0 events
        if (results.length === 0) {
            res.send([]); // Return an empty array
        } else {
            res.send(results);
        }
    } catch (err) {
        return handleApiError(
            res,
            err,
            "An error occurred while getting events for a user"
        );
    }
});

/**
 * Changes a password. Only the user as themselves or an admin can change a password.
 */
userRouter.patch("/:userId/password", async (req, res) => {
    try {
        // await checkUserPermissions(req.role, req.params.userId, req.auth.user);

        console.log(`new Password ${req.body.newPassword}`);
        const passwordHashSalt = bcrypt.hashSync(req.body.newPassword, 10);

        let queryParams;
        let whereClause;

        if (req.role !== "admin") {
            // Need to check value of email too, if user is not an admin
            whereClause = `WHERE userId = ? and email = ?`;
            queryParams = [passwordHashSalt, req.params.userId, req.auth.user];
        } else {
            whereClause = `WHERE userId = ?`;
            queryParams = [passwordHashSalt, req.params.userId];
        }

        console.log(`whereClause ${whereClause}`);

        const results = (
            await pool.query<ResultSetHeader>(
                `UPDATE USER
                 SET password = ?
                 ${whereClause}`,
                queryParams
            )
        )[0];

        if (results.affectedRows === 0) {
            res.status(404).send("User not found");
        } else {
            res.sendStatus(204);
        }
    } catch (err) {
        return handleApiError(
            err,
            res,
            "An error occurred while updating a user's password"
        );
    }
});

export {};

module.exports = {
    userRouter,
};
