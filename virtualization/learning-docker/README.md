# Learning Docker

Docker is an open-source platform that automates the deployment, scaling, and management of applications using lightweight, containerized environments. It allows developers to package an application along with all its dependencies (libraries, configuration files, runtime, etc.) into a **container**. These containers can run consistently across different environments, whether on a developer's machine, a test server, or in production.

## Key Concepts:
1. **Containers**: Lightweight, standalone, and executable units that include everything needed to run an application. Unlike virtual machines, containers share the host's operating system, making them faster and more efficient.

2. **Images**: Read-only templates used to create containers. They are built using `Dockerfile` instructions and include the application code, environment variables, dependencies, and configuration.

3. **Docker Engine**: The core component of Docker that creates, manages, and runs containers. It can be installed on any operating system.

4. **Docker Hub**: A cloud-based registry where Docker images are stored and shared. Developers can pull official or custom images from Docker Hub to build their containers.

## Benefits:
- **Portability**: Containers run the same way on any system, ensuring that applications work consistently across different environments.
- **Efficiency**: Containers are lightweight because they share the host OS, using fewer resources compared to traditional virtual machines.
- **Scalability**: Docker makes it easy to scale applications by running multiple instances of containers in a cluster.

## Example Use Case:
A developer can build a web application in a container on their local machine. When the app is deployed to a server, it will run exactly as it did locally, eliminating the "works on my machine" problem.

Docker is widely used in **DevOps**, **microservices architecture**, and **continuous integration/continuous deployment (CI/CD)** pipelines to streamline development and production workflows.

---

## **1. Docker Images**
- **What are Images?**
  Docker images are the blueprints for containers. They contain everything needed to run a container, such as the application code, runtime, libraries, and dependencies.

- **Key Points:**
  - **Immutable**: Once an image is created, it can't be changed.
  - **Layered**: Built in layers, where each instruction in a `Dockerfile` adds a new layer, making image creation efficient.
  - **Image Registry**: Images are stored in repositories like Docker Hub or a private registry.

- **Common Commands:**
  - Pull an image from Docker Hub:
    ```bash
    docker pull <image_name>
    ```
  - Build an image from a Dockerfile:
    ```bash
    docker build -t <image_name>:<tag> .
    ```
  - List images:
    ```bash
    docker images
    ```
  - Remove an image:
    ```bash
    docker rmi <image_name>
    ```

---

## **2. Docker Volumes**
- **What are Volumes?**
  Docker volumes are used to persist data outside of containers. Containers are ephemeral, meaning data inside them is lost when they stop or are removed. Volumes solve this by storing data on the host machine.

- **Types of Storage:**
  - **Bind Mounts**: Directly map a host directory to the container.
  - **Volumes**: Managed by Docker, preferred for portable, data persistence.

- **Key Points:**
  - **Decouples data**: Ensures that data remains even when containers are recreated.
  - **Shared Access**: Volumes can be shared among multiple containers.

- **Common Commands:**
  - Create a volume:
    ```bash
    docker volume create <volume_name>
    ```
  - Run a container with a volume:
    ```bash
    docker run -v <volume_name>:/path/in/container <image_name>
    ```
  - List volumes:
    ```bash
    docker volume ls
    ```
  - Remove a volume:
    ```bash
    docker volume rm <volume_name>
    ```

---

## **3. Docker Networks**
- **What are Networks?**
  Docker networks allow containers to communicate with each other and with the outside world. By default, containers on the same network can communicate.

- **Types of Networks:**
  - **Bridge**: Default network for containers. Containers on the same bridge can communicate, but not with the host or other bridges.
  - **Host**: Directly connects to the host’s network stack, offering high performance, but containers lose isolation from the host.
  - **Overlay**: Used for multi-host networking, enabling communication between containers on different machines.

- **Key Points:**
  - **Isolation**: By creating networks, you control which containers can communicate with each other.
  - **DNS Resolution**: Docker automatically provides DNS resolution between containers on the same network.

- **Common Commands:**
  - List networks:
    ```bash
    docker network ls
    ```
  - Create a network:
    ```bash
    docker network create <network_name>
    ```
  - Run a container on a specific network:
    ```bash
    docker run --network <network_name> <image_name>
    ```
  - Connect a running container to a network:
    ```bash
    docker network connect <network_name> <container_id>
    ```

---

## **How They Work Together**
- **Images** provide the base for containers.
- **Volumes** persist data generated by containers beyond the container’s lifecycle.
- **Networks** allow containers to communicate securely and effectively with each other or the host machine.

This setup allows for scalable, isolated, and resilient environments for running applications.

---

## **Basic Commands**
- **Check Docker version**
  ```bash
  docker --version
  ```

- **List Docker system info**
  ```bash
  docker info
  ```

- **Login to Docker Hub**
  ```bash
  docker login
  ```

## **Container Management**

- **List running containers**
  ```bash
  docker ps
  ```

- **List all containers (including stopped ones)**
  ```bash
  docker ps -a
  ```

- **Start a container**
  ```bash
  docker start <container_id or name>
  ```

- **Stop a container**
  ```bash
  docker stop <container_id or name>
  ```

- **Restart a container**
  ```bash
  docker restart <container_id or name>
  ```

- **Remove a container**
  ```bash
  docker rm <container_id or name>
  ```

- **Run a container (and enter the bash shell)**
  ```bash
  docker run -it <image_name> /bin/bash
  ```

- **Run a container in the background (detached mode)**
  ```bash
  docker run -d <image_name>
  ```

- **Execute command inside running container**
  ```bash
  docker exec -it <container_id or name> /bin/bash
  ```

- **Stop all running containers**
  ```bash
  docker stop $(docker ps -q)
  ```

- **Remove all stopped containers**
  ```bash
  docker rm $(docker ps -a -q)
  ```

---

## **Image Management**

- **List all images**
  ```bash
  docker images
  ```

- **Pull an image from Docker Hub**
  ```bash
  docker pull <image_name>
  ```

- **Remove an image**
  ```bash
  docker rmi <image_name or id>
  ```

- **Tag an image for a repository**
  ```bash
  docker tag <image_id> <repository_name>:<tag>
  ```

- **Push an image to Docker Hub**
  ```bash
  docker push <repository_name>:<tag>
  ```

- **Build an image from a Dockerfile**
  ```bash
  docker build -t <image_name>:<tag> <path_to_dockerfile>
  ```

- **Remove all unused images**
  ```bash
  docker image prune
  ```

---

## **Volumes**

- **List volumes**
  ```bash
  docker volume ls
  ```

- **Create a volume**
  ```bash
  docker volume create <volume_name>
  ```

- **Remove a volume**
  ```bash
  docker volume rm <volume_name>
  ```

- **Run a container with a volume**
  ```bash
  docker run -v <volume_name>:/path/in/container <image_name>
  ```

- **Remove unused volumes**
  ```bash
  docker volume prune
  ```

---

## **Network**

- **List networks**
  ```bash
  docker network ls
  ```

- **Create a network**
  ```bash
  docker network create <network_name>
  ```

- **Connect a container to a network**
  ```bash
  docker network connect <network_name> <container_id>
  ```

- **Disconnect a container from a network**
  ```bash
  docker network disconnect <network_name> <container_id>
  ```

- **Remove a network**
  ```bash
  docker network rm <network_name>
  ```

---

## **Docker Compose**

- **Start services in background**
  ```bash
  docker-compose up -d
  ```

- **Stop services**
  ```bash
  docker-compose down
  ```

- **View logs**
  ```bash
  docker-compose logs
  ```

- **Restart a service**
  ```bash
  docker-compose restart <service_name>
  ```

---

This cheat sheet covers most of the common Docker commands to manage containers, images, networks, and volumes. Let me know if you need further explanations!

## Further Reading

1. [Docker Docs](https://docs.docker.com/)
2. [Docker Tagging: Best practices for tagging and versioning docker images](https://stevelasker.blog/2018/03/01/docker-tagging-best-practices-for-tagging-and-versioning-docker-images/)
3. [Docker Cheatsheet](https://dev.to/vishnuchilamakuru/docker-cheatsheet-39fa)
4. [Awesome Docker Compose](https://github.com/docker/awesome-compose)

## Videos

1. [Docker For Beginners: From Docker Desktop to Deployment](https://youtu.be/i7ABlHngi1Q)