// // server.js
const express = require('express');
const os = require('os');

const app = express();
const port = process.env.PORT || 8080;

// Root route
app.get('/', (req, res) => {
  res.send(`
    <h1>🚀 Node.js App Deployed on AWS Elastic Beanstalk!</h1>
    <p>Welcome to your environment running on <b>${os.platform()}</b></p>
  `);
});

// Health check route (for EB)
app.get('/health', (req, res) => {
  res.json({ status: 'ok', uptime: process.uptime() });
});

// Start server
app.listen(port, () => {
  console.log(`✅ Server is running on port ${port}`);
});
