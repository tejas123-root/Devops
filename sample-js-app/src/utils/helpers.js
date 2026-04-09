function generateId() {
  return Math.random().toString(36).slice(2, 11);
}

function formatResponse(data, message = 'Success') {
  return { message, data };
}

module.exports = { generateId, formatResponse };
