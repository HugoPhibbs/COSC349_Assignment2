# Event Calendar
- This repo contains code to launch a website called "EventCalendar", which allows users to create and manage events associated with the University of Otago

## How to run

### Running on a VM
- If you wish to start the website on a new virtual machine
- To start via vagrant, and create a VM with the website running on it, run the following command in the root directory of the repo
```shell
vagrant up
```

### Running locally with Docker
- If you don't wish to boot up a new VM, you can run locally with docker:
- To start via Docker, and create website containers locally on your machine. From the root level of the project, enter;
```shell
cd ./provision
chmod +x ./start_docker.sh
./start_docker.sh
```

### Viewing the website
- In either case (VM or Docker route) to see the development website, visit http://localhost:3000/

## System structure
- The website is composed of 3 main parts - a MySQL database, an Express.js API, and a React front end.
- A simplified system diagram is shown below, including the interaction between each component

![](https://github.com/HugoPhibbs/COSC349_Assignment1_EventCalendar/blob/master/system.png)


## Development
- Both the React and Express app are written in TypeScript



