# BYFA

Welcome to **BYFA** – your go-to tool for kickstarting API projects in various frameworks and programming languages!

## Description

**BYFA** is a command-line interface (CLI) application designed to streamline the process of creating base projects for APIs using different frameworks and programming languages. Whether you're diving into a new language or framework or simply want to expedite the project setup process, **BYFA** has got you covered.

## Purpose

**BYFA** stands for "Build Your First API". Our mission is to empower developers in their journey to learn new languages and frameworks by providing a simple yet powerful tool to kickstart their first API projects. Learning a new technology can be daunting, but with **BYFA**, you can quickly scaffold a basic project and focus on learning the intricacies of the language or framework.

## Features

- **Framework Flexibility:** Choose from a variety of popular frameworks and programming languages to generate your API project.
- **Project Customization:** Tailor your project setup with options for database integration, authentication, and more.
- **Rapid Prototyping:** Get up and running with your API project in minutes, allowing you to iterate and experiment efficiently.

## Supported Frameworks (Beta)

At the moment, **BYFA** is in beta and supports the following framework:

- **Express**

We're actively working to expand our framework support, and on our first release, we plan to support:

- **Express**
- **Go (net/http)**
- **NestJS**
- **Rust (TBD)**
- **FastAPI**

## Documentation (In Progress)

Documentation for **BYFA** is currently in progress. We're working hard to provide comprehensive guides and usage instructions. Stay tuned!

## Getting Started

To get started with **BYFA**, follow these simple steps:

1. Clone the repository: `git clone https://github.com/charlinchui/byfa-cli.git`
2. Navigate to the project directory: `cd byfa-cli`
3. Build the project: `go build`
4. Run `byfa` from your terminal and follow the prompts to generate your API project.
5. Dive into your new project and start building your API!

### Usage: Express

- **Command:** `byfa express`
- **Options:**
  - `-n, --name <api-name>`: Specify the name of your API.
  - `-l, --location <location>`: Specify the location where the project will be created. Default is the current directory.
- **Example:** `byfa express -n my-super-awesome-api -l .`
- **Description:** Creates the base Express project for an API named my-super-awesome-api at the current location.
- **Requirements:** Node.js and npm installed.

## Contributing

**BYFA** is an open-source project, and we welcome contributions from the community. Whether you're a seasoned developer or just getting started, there are plenty of ways to get involved:

- **Feature Requests:** Have an idea for a new feature? We'd love to hear it! Open an issue and share your thoughts.
- **Bug Reports:** Encounter a bug? Let us know by opening an issue, and we'll work to address it promptly.
- **Code Contributions:** Fork the repository, make your changes, and submit a pull request. We appreciate all contributions, big or small!

Check the code of conduct [here!](https://github.com/charlinchui/byfa-cli?tab=coc-ov-file)

### embed.go

The `embed.go` file is a crucial component of **BYFA**. It is responsible for embedding shell files into Go code, enabling their usage during the build process. This allows **BYFA** to include essential scripts directly in the generated binary/executable file.

Please note that `embed.go` will not be built automatically when running `go build`. Instead, it is used during the `go generate` step to embed the shell files into the Go code.

For more information on how `embed.go` works, refer to the comments within the file.

## License

**byfa** is licensed under the [MIT License](https://github.com/charlinchui/byfa-cli?tab=MIT-1-ov-file). Feel free to use, modify, and distribute it according to your needs.

---

Thank you for choosing **BYFA**. Happy coding!
