# Event Calendar

- This repo contains code to launch a website called "EventCalendar", which allows users to create and manage events
  associated with the University of Otago

## How to run

- To start via Docker, and create website containers locally on your machine. From the root level of the project, enter:

```shell
docker compose up
```
- After entering this command, pay attention to the logs; the website is ready when you see `Compiled sucessfully!...` from `react-container`

- To stop the containers, and clear any container volumes (possibly necessary to allow recent code changes to take effect), enter:
```shell
docker compose down -v
```

## How to build

- To rebuild container images after any source code changes, enter the command:

```
docker compose build
```

### Viewing the website

- To view the development website, visit http://localhost:3000/

## System structure

- The website is composed of 3 main parts - a MySQL database, an Express.js API, and a React front end.
- The Express.js API contains all the routes necessary for the React app to indirectly interact with the DB - providing
  plumbing code where necessary.
- A simplified system diagram is shown below, including the interaction between each component

![](https://github.com/HugoPhibbs/COSC349_Assignment1_EventCalendar/blob/master/system.png)

## Development

- Both the React and Express app are written in TypeScript



