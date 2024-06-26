const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');
require('dotenv').config()
const path = require('path')

const app = express();
const PORT = 3001

const apiTarget = process.env.API_HOST

app.use(express.static(path.join(__dirname, 'build')));

app.use('/', createProxyMiddleware({ target: apiTarget, changeOrigin: true, pathRewrite: { '^/api': '' } }));

app.listen(PORT, () => {
    console.log(`Proxy server listening on port ${PORT}`)
})
