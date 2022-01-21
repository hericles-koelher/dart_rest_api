<h1 align="center">
   <a href="#"> Dart REST API </a>
</h1>

<h3 align="center">
    A simple REST API made using the dart language.
</h3>

<p align="center">
  <img alt="Repository size" src="https://img.shields.io/github/repo-size/hericles-koelher/dart_rest_api">

  <a href="https://github.com/hericles-koelher/dart_rest_api/blob/master/README.md">
    <img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/hericles-koelher/dart_rest_api">
  </a>

   <img alt="License" src="https://img.shields.io/badge/license-MIT-brightgreen">

  <a href="https://twitter.com/HericlesKoelher">
    <img alt="made by Hericles Koelher" src="https://img.shields.io/badge/made%20by-Hericles_Koelher-%237519C1">
  </a>

</p>

<h4 align="center">
	 Status: Finished
</h4>

<p align="center">
 <a href="#about">About</a> •
 <a href="#features">Features</a> •
 <a href="#how-it-works">How it works</a> •
 <a href="#tech-stack">Tech Stack</a> •
 <a href="#author">Author</a> •
 <a href="#user-content-license">License</a>

</p>

---

## About

Dart REST API is just an little project made with the purpose of study back-end development with [Dart](https://dart.dev).

---

## Features

- [x] User register
- [x] User auth with JsonWebToken
- [x] User account update
- [x] User account delete
- [x] CRUD operations with [Expressions](./lib/src/domain/entities/expression.dart)
- [x] Only logged users have authorization to access data from "expressions" endpoint

---

## How it works

This API has only two endpoints:

- Auth
- Expressions

**Note**: To realize actions as an authenticated user it's required the request header contains the field "Authorization" with the following value "Bearer {accessToken}", where {accessToken} should be replaced with your auth token.

### Endpoint _/auth_

---

This endpoint handle all actions related to an user:

- Register
- Login/Logout
- Update Info
- Delete Account

<br />

#### **[POST]** _/auth/register_

**Description**: Register an user on system. On success returns an answer with status code 201 and a string with a success message. In case this process fail, then returns an answer with status 4XX and a string with a better description of the problem.

Examples:

- Request address:

  ```HTTP
  http://localhost:8080/auth/register
  ```

- Request body::

  ```JSON
  {
    "username" : "Dobby",
    "email" : "dobbyIsAFreeElf@gmail.com",
    "password" : "#FreeElves"
  }
  ```

- Answer:

  ```
  User successfully registered
  ```

<br />

#### **[POST]** _/auth/login_

**Description**: Performs the user login on system. On success returns an answer with status code 200 and a [JSON](https://www.json.org/json-en.html) with two 'tokens', being one for auth (expires in 15 minutes) and the other to renew the first one (expires in 30 minutes). In case this process fail, then returns an answer with status 4XX and a string with a better description of the problem.

Examples:

- Request address:

  ```HTTP
  http://localhost:8080/auth/login
  ```

- Request body:

  ```JSON
  {
    "email" : "dobbyIsAFreeElf@gmail.com",
    "password" : "#FreeElves"
  }
  ```

- Answer:

  ```JSON
  {
    "token" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NDI3NzEzMDYsImV4cCI6MTY0Mjc3MzEwNiwic3ViIjoiMSIsImlzcyI6ImxvY2FsaG9zdCIsImp0aSI6IjA2ZmVhZmI5LTA4MTEtNGRhZS05YTljLTc5NjBmNzVlYTZhMSJ9.76LagMOKPVgY0-ZScMDhlRjpwvbXESqUCGDhbbPPbQQ",
    "refreshToken" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NDI3NzEzMDYsImV4cCI6MTY0Mjc3NDkwNiwic3ViIjoiMSIsImlzcyI6ImxvY2FsaG9zdCIsImp0aSI6IjA2ZmVhZmI5LTA4MTEtNGRhZS05YTljLTc5NjBmNzVlYTZhMSJ9.A4YkORrXTZOjnANhisPRSAED_PLgLTA6biIVkSz11pk"
  }
  ```

<br />

#### **[POST]** _/auth/refreshToken_

**Description**: Renew an user token on system. On success returns an answer with status code 200 and a [JSON](https://www.json.org/json-en.html) with two 'tokens', being one for auth (expires in 15 minutes) and the other to renew the first one (expires in 30 minutes). In case this process fail, then returns an answer with status 4XX and a string with a better description of the problem.

Examples:

- Request address:

  ```HTTP
  http://localhost:8080/auth/refreshToken
  ```

- Request body:

  ```JSON
  {
    "refreshToken" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NDI3NzEzMDYsImV4cCI6MTY0Mjc3NDkwNiwic3ViIjoiMSIsImlzcyI6ImxvY2FsaG9zdCIsImp0aSI6IjA2ZmVhZmI5LTA4MTEtNGRhZS05YTljLTc5NjBmNzVlYTZhMSJ9.A4YkORrXTZOjnANhisPRSAED_PLgLTA6biIVkSz11pk"
  }
  ```

- Answer:

  ```JSON
  {
    "token" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NDI3NzI1MDMsImV4cCI6MTY0Mjc3NDMwMywic3ViIjoiMSIsImlzcyI6ImxvY2FsaG9zdCIsImp0aSI6Ijc0ODYyMzUzLWQwZmUtNDk4OC1iOWQwLWZiN2YyNTJhZjI3YyJ9.QEqezAmz333iQNVpsWG6UZUidLDOKHgx2KWyc-lW9KI",
    "refreshToken" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NDI3NzI1MDMsImV4cCI6MTY0Mjc3NjEwMywic3ViIjoiMSIsImlzcyI6ImxvY2FsaG9zdCIsImp0aSI6Ijc0ODYyMzUzLWQwZmUtNDk4OC1iOWQwLWZiN2YyNTJhZjI3YyJ9.SjmSc23465l35-kJQneEfFe8mTohv9G9FSiZ0-2oFIM"
  }
  ```

<br />

#### **[POST]** _/auth/logout_

**Description**: Performs an user logout on system and revoke their renew token. On success returns an answer with status code 200 and and a string with a success message. In case this process fail, then returns an answer with status 4XX and a string with a better description of the problem (probably unauthorized user exception).

Examples:

- Request address:

  ```HTTP
  http://localhost:8080/auth/logout
  ```

- Answer:

  ```
  Successfully logged out
  ```

<br />

#### **[PUT]** _/auth/updateInfo_

**Description**: Updates an user info on system. On success returns an answer with status code 200 and a string with a success message. In case this process fail, then returns an answer with status 4XX and a string with a better description of the problem.

Examples:

- Request address:

  ```HTTP
  http://localhost:8080/auth/updateInfo
  ```

- Request body:

  ```JSON
  {
    "username" : "Free Dobby",
    "email" : "justDobby@gmail.com",
    "password" : "ThanksHarry"
  }
  ```

- Answer

  ```
  User information successfully updated
  ```

<br />

#### **[DELETE]** _/auth/deleteAccount_

**Description**: Deletes an user on system and revokes their renew token. On success returns an answer with status code 200 and a string with a success message. In case this process fail, then returns an answer with status 4XX and a string with a better description of the problem (probably unauthenticated user exception).

Examples:

- Request address:

  ```HTTP
  http://localhost:8080/auth/deleteAccount
  ```

- Answer:

  ```
  User successfully deleted
  ```

### Endpoint _/expressions_

---

This endpoint make it possible to an authenticated user perform CRUD operations on [Expressions](./lib/src/domain/entities/expression.dart).

<br />

#### **[POST]** _/expressions_

**Description**: Creates an expression on system. On success returns an answer with status code 201 and a JSON with the created expression. In case this process fail, then returns an answer with status 4XX and a string with a better description of the problem.

Examples:

- Request address:

  ```HTTP
  http://localhost:8080/expressions
  ```

- Request body::

  ```JSON
  {
    "expression" : "Go on a wild goose chase",
    "meaning" : "To do something pointless"
  }
  ```

- Answer:

  ```JSON
  {
    "id" : 1,
    "expression" : "Go on a wild goose chase",
    "meaning" : "To do something pointless",
    "lastUpdate" : "2022-01-21T13:58:06.578517"
  }
  ```

<br />

#### **[GET]** _/expressions_

**Description**: Get all expressions on system. On success returns an answer with status code 200 and a JSON with a list of expressions. In case this process fail, then returns an answer with status 4XX and a string with a better description of the problem.

Examples:

- Request address:

  ```HTTP
  http://localhost:8080/expressions
  ```

- Answer:

  ```JSON
  [
    {
    "id" : 0,
    "expression" : "Get a taste of your own medicine",
    "meaning" : "Get treated the way you've been treating others (negative)",
    "lastUpdate" : "2022-01-19T19:34:09.244124"
    },
    {
    "id" : 1,
    "expression" : "Go on a wild goose chase",
    "meaning" : "To do something pointless",
    "lastUpdate" : "2022-01-21T13:58:06.578517"
    }
  ]
  ```

<br />

#### **[GET]** _/expressions/{id}_

**Description**: Get an expression on system. On success returns an answer with status code 200 and a JSON with the referred expression. In case this process fail, then returns an answer with status 4XX and a string with a better description of the problem.

Examples:

- Request address:

  ```HTTP
  http://localhost:8080/expressions/1
  ```

- Answer:

  ```JSON
  {
    "id" : 1,
    "expression" : "Go on a wild goose chase",
    "meaning" : "To do something pointless",
    "lastUpdate" : "2022-01-21T13:58:06.578517"
  }
  ```

<br />

#### **[PUT]** _/expressions/{id}_

**Description**: Updates an expression on system. On success returns an answer with status code 200 and a JSON with the updated expression. In case this process fail, then returns an answer with status 4XX and a string with a better description of the problem.

Examples:

- Request address:

  ```HTTP
  http://localhost:8080/expressions/1
  ```

- Request body::

  ```JSON
  {
    "expression" : "Go on a wild goose chase",
    "meaning" : "Bla bla bla",
  }
  ```

- Answer:

  ```JSON
  {
    "id" : 1,
    "expression" : "Go on a wild goose chase",
    "meaning" : "Bla bla bla",
    "lastUpdate" : "2022-01-21T13:59:06.384333"
  }
  ```

<br />

#### **[DELETE]** _/expressions/{id}_

**Description**: Deletes an expression on system. On success returns an answer with status code 204. In case this process fail, then returns an answer with status 4XX and a string with a better description of the problem.

Examples:

- Request address:

  ```HTTP
  http://localhost:8080/expressions/1
  ```

### Pre-requisites

Before you begin, you will need to have [Docker](https://www.docker.com/) installed and configured in your machine.

#### Running the application

From the root folder run docker-compose and create the necessary containers.

```bash
$ docker-compose up -d
```

---

## Tech Stack

The following tools were used in the construction of the project:

#### **Mobile**

- **[Dart](https://dart.dev)**
- **[Shelf](https://pub.dev/packages/shelf)**
- **[Docker](https://www.docker.com/)**
- **[MongoDB](https://www.mongodb.com/)**
- **[Redis](https://redis.io/)**
- **[JSON Web Token](https://jwt.io/)**

#### **Utilities**

- Editor: **[Visual Studio Code](https://code.visualstudio.com/)** → Plugin: **[Flutter](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)**, **[Dart](https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code)**

---

## Author

<div>
 <img style="border-radius: 50%;" src="https://avatars.githubusercontent.com/u/34146602?v=4" width="100px;" alt="Hericles Koelher"/>
 <br />
 <sub><b>Hericles Koelher</b></sub>
</div>

[![Twitter Badge](https://img.shields.io/badge/-@HericlesKoelher-1ca0f1?style=flat-square&labelColor=1ca0f1&logo=twitter&logoColor=white&link=https://twitter.com/HericlesKoelher)](https://twitter.com/HericlesKoelher) [![Linkedin Badge](https://img.shields.io/badge/-Hericles_Koelher-blue?style=flat-square&logo=Linkedin&logoColor=white&link=https://www.linkedin.com/in/hericles-bruno-quaresma-koelher-9a2021209)](https://www.linkedin.com/in/hericles-bruno-quaresma-koelher-9a2021209)

---

## License

This project is under the license [MIT](./LICENSE).

Made with love by Hericles Koelher
