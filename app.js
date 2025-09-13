const express = require('express');
const path = require('path');
const app = express();

const PORT = process.env.PORT || 3050;

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'logoswayatt.png'));
});

app.listen(PORT, () => {
  console.log('Server running on http://localhost:${PORT}');
});
