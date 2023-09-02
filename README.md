# Event Calendar

- This repo contains code to launch a website called "EventCalendar", which allows users to create and manage events
  associated with the University of Otago

## Building and Deploying

### How to run

- To start via Docker, and create website containers locally on your machine. From the root level of the project, enter:

```shell
docker compose up
```
- After entering this command, pay attention to the logs; the website is ready when you see `INFO  Accepting connections at http://localhost:3000` logged from `react-container`.

- To stop the containers, enter:
```shell
docker compose down -v
```

### How to build

- To rebuild container images after any source code changes, enter the command:

```
docker compose build
```

## Viewing the website

- To view the development website, visit http://localhost:3000/

## System Structure
- The website is composed of 3 main parts - a MySQL database, an Express.js API, and a React front end.
- The Express.js API contains all the routes necessary for the React app to indirectly interact with the DB - providing
  plumbing code where necessary.
- A simplified system diagram is shown below, including the interaction between each component

![](https://github.com/HugoPhibbs/COSC349_Assignment1_EventCalendar/blob/master/system.png)

- The containers interact with each other using HTTP requests via Docker's network capabilities.

## Future Development
- The application is deployed using a top level Docker compose file. This file creates and deploys the containers
  from prebuilt and custom images.
- The Node.js modules are written using Typescript.

### Project directories
- `express-server` contains a Node.js project for the backend express.js API. Contains a Dockerfile to specify the Express container image.
- `react-app` contains a Node.js project for the frontend React app. Contains a Dockerfile to specify the React container image.
- `mysql-db` contains any configuration scripts of the MySQL container, along with any volumes for the MySQL DB container.