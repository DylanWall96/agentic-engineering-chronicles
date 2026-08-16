# Acme Payments Service

This is a Node.js project. Node.js is a JavaScript runtime built on Chrome's
V8 engine. It uses an event-driven, non-blocking I/O model.

## Directory structure

- src/            source code
- src/api/        API handlers
- src/db/         database layer
- src/utils/      utilities
- docs/           documentation
- test/           tests

## Dependencies

express, pg, redis, jsonwebtoken, bcrypt, dotenv, winston, jest, supertest,
eslint, prettier, nodemon, typescript, ts-node, @types/node, @types/express

## Code style

- Use 2 spaces for indentation, never tabs.
- Always use semicolons at the end of statements.
- Prefer const over let. Never use var.
- Use single quotes for strings.
- Maximum line length is 100 characters.
- Always use arrow functions for callbacks.
- Use camelCase for variables and PascalCase for classes.

## Git conventions

Commit messages should be in the imperative mood. Branch names should be
prefixed with feature/, fix/, or chore/.

## How to write good JavaScript

Avoid callback hell by using promises or async/await. Handle errors properly.
Don't mutate function arguments. Use strict equality. Avoid global variables.

## Commands

npm install, npm test, npm run lint, npm run build, npm start, npm run dev,
npm run migrate, npm run seed, npm run docker:build, npm run docker:up

## Safety

Never commit secrets. Migrations in src/db/migrations require review.
