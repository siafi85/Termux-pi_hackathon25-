#!/data/data/com.termux/files/usr/bin/bash

# إنشاء package.json
cat > package.json <<EOL
{
  "name": "pi_hackathon25",
  "version": "1.0.0",
  "description": "",
  "main": "server.js",
  "scripts": {
    "dev": "node server.js",
    "start": "node server.js",
    "test": "echo \\"Error: no test specified\\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "dependencies": {
    "body-parser": "^2.2.0",
    "cors": "^2.8.5",
    "dotenv": "^17.2.1",
    "express": "^5.1.0"
  },
  "devDependencies": {
    "nodemon": "^3.1.10",
    "eslint": "^9.34.0"
  }
}
EOL

# إنشاء server.js
cat > server.js <<EOL
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(bodyParser.json());

app.get('/', (req, res) => {
  res.send('Hello from Pi Hackathon!');
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(\`Server running on http://localhost:\${PORT}\`);
});
EOL

# تثبيت الحزم
npm install

echo "✅ Setup completed! You can now run: npm run dev"
