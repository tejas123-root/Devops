const { generateId, formatResponse } = require('../utils/helpers');

// In-memory store (replace with a database in production)
let users = [
  { id: '1', name: 'Alice', email: 'alice@example.com' },
  { id: '2', name: 'Bob',   email: 'bob@example.com'   },
];

function getAllUsers(req, res) {
  res.json(formatResponse(users));
}

function getUserById(req, res) {
  const user = users.find(u => u.id === req.params.id);
  if (!user) return res.status(404).json({ error: 'User not found' });
  res.json(formatResponse(user));
}

function createUser(req, res) {
  const { name, email } = req.body;
  if (!name || !email) {
    return res.status(400).json({ error: 'name and email are required' });
  }
  const newUser = { id: generateId(), name, email };
  users.push(newUser);
  res.status(201).json(formatResponse(newUser, 'User created'));
}

function updateUser(req, res) {
  const index = users.findIndex(u => u.id === req.params.id);
  if (index === -1) return res.status(404).json({ error: 'User not found' });
  users[index] = { ...users[index], ...req.body, id: req.params.id };
  res.json(formatResponse(users[index], 'User updated'));
}

function deleteUser(req, res) {
  const index = users.findIndex(u => u.id === req.params.id);
  if (index === -1) return res.status(404).json({ error: 'User not found' });
  users.splice(index, 1);
  res.json({ message: 'User deleted' });
}

module.exports = { getAllUsers, getUserById, createUser, updateUser, deleteUser };
