import express from "express";
const serverless = require("serverless-http"); // For AWS Lambda

const dotenv = require("dotenv");
dotenv.config();

export {};

const app = require("./app").app;

// Final Setup
const PORT = process.env.PORT || 3001;

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});

module.exports = {
    app,
    handler: serverless(app),
};
