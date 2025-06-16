# Javalivro

Javalivro is a simple web bookstore built with Java Servlets and JSP. The project demonstrates a basic shopping cart, an administrative area, and integration with a MySQL database.

## Prerequisites

- **Java 21 or later** – the project targets JavaSE-21 as defined in the Eclipse configuration.
- **Servlet container** – such as Apache Tomcat 9 to deploy the application.
- **MySQL database** – connection parameters can be adjusted in [`DatabaseConnection.java`](src/main/java/com/livraria/dao/DatabaseConnection.java).
- **Database schema** – SQL scripts are located in [`database/`](database/) and should be executed before running the application.

## Building

This repository does not include a Maven or Gradle build. You can compile the sources manually or import the project into an IDE that supports Java web projects (for example Eclipse).

To compile via the command line:

```bash
javac -d build/classes -classpath "src/main/webapp/WEB-INF/lib/*" $(find src/main/java -name '*.java')
```

You may also set up Maven or Gradle to manage dependencies if preferred. Refer to the official documentation for setup instructions: [Maven](https://maven.apache.org/) or [Gradle](https://gradle.org/).

## Running

1. Ensure MySQL is running and that the `DatabaseConnection` configuration matches your local credentials.
2. Execute the SQL files in the `database/` directory to create the required tables.
3. Deploy the contents of `src/main/webapp` together with the compiled classes in `build/classes` to your servlet container (e.g., copy them into Tomcat's `webapps/javalivro`).
4. Start the container and access the bookstore at `http://localhost:8080/javalivro`.

This project is intended for educational purposes and may require additional setup (database schema, user accounts) depending on your environment.

## License

This project is licensed under the [MIT License](LICENSE).


