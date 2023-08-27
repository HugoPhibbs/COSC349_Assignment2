# Event Calendar

- This repo contains code to launch a website called "EventCalendar", which allows users to create and manage events
  associated with the University of Otago

## How to run

### Running on a VM

- If you wish to start the website on a new virtual machine
- To start via vagrant, and create a VM with the website running on it, run the following command in the root directory
  of the project:

```shell
vagrant up
```

- To stop (destroy) the VM, enter:
```shell
vagrant destroy
```

### Running locally with Docker

- If you don't wish to boot up a new VM, you can run locally with docker:
- To start via Docker, and create website containers locally on your machine. From the root level of the project, enter:

```shell
docker compose -f ./provision/compose.yml up
```
- After entering this command, pay attention to the logs; the website is ready when you see `Compiled sucessfully!...` from `react-container`.

- To stop the containers, enter:
```shell
docker compose -f ./provision/compose.yml down
```

### Viewing the website

- In either case (using VM or Docker) to see the development website, visit http://localhost:3000/

## System structure

- The website is composed of 3 main parts - a MySQL database, an Express.js API, and a React front end.
- The Express.js API contains all the routes necessary for the React app to indirectly interact with the DB - providing
  plumbing code where necessary.
- A simplified system diagram is shown below, including the interaction between each component

![](https://github.com/HugoPhibbs/COSC349_Assignment1_EventCalendar/blob/master/system.png)

## Development

- Both the React and Express app are written in TypeScript



