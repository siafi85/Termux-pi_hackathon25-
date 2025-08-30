const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
app.use(cors());
app.use(bodyParser.json());

// GET /
app.get('/', (req, res) => {
  res.send('Hello from Pi Hackathon!');
});

// POST /check-user
app.post('/check-user', (req, res) => {
  const { userId } = req.body;
  if (!userId) return res.status(400).json({ error: 'userId مطلوب' });

  res.json({
    userId: userId,
    status: 'تم التحقق بنجاح (نموذج تجريبي)',
    balance: 100
  });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
