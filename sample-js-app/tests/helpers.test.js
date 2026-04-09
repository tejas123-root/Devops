const { describe, it } = require('node:test');
const assert = require('node:assert/strict');
const { generateId, formatResponse } = require('../src/utils/helpers');

describe('generateId', () => {
  it('returns a non-empty string', () => {
    const id = generateId();
    assert.equal(typeof id, 'string');
    assert.ok(id.length > 0);
  });

  it('generates unique ids', () => {
    const ids = new Set(Array.from({ length: 100 }, generateId));
    assert.equal(ids.size, 100);
  });
});

describe('formatResponse', () => {
  it('wraps data with default message', () => {
    const result = formatResponse({ name: 'Alice' });
    assert.deepEqual(result, { message: 'Success', data: { name: 'Alice' } });
  });

  it('uses custom message when provided', () => {
    const result = formatResponse([], 'No users');
    assert.equal(result.message, 'No users');
  });
});
