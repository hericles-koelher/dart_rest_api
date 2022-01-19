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
	 Status: Under Development
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

Dart REST API - is just an little project made with the purpose of study back-end development with [Dart](https://dart.dev).

---

## Features

- [x] User register
- [x] User auth with JsonWebToken
- [ ] User account update
- [ ] User account delete
- [x] CRUD operations with [Expressions](./lib/src/domain/entities/expression.dart)
- [x] Only logged users have authorization to access data from "expressions" endpoint

---

## How it works

--- [ Session Under Development ] ---

### Pre-requisites

Before you begin, you will need to have [Dart](https://dart.dev/), [Docker](https://www.docker.com/) and any IDE of your choice installed and configured in your machine.

#### Running the application

Step 1 - From the root folder run docker-compose and create the necessary containers.

```bash
$ docker-compose up -d
```

Step 2 - Open the project with your IDE and run it by clicking play or via command line with:

```bash
# command line in the root of your project
$ dart run bin/server.dart
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
