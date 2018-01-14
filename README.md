# Recipe for Dockerizing Hippo CMS

This recipe explains how to dockerize a Hippo CMS project, using [Dockerfile Maven Plugin](https://github.com/spotify/dockerfile-maven) and a Dockerfile, based on the existing maven profiles such as ```mvn -P dist```, for simplicity.

## Steps Overview

- Step 1: Review and Correct Project Distribution Profile(s).
- Step 2: **\[Dockerization\]** Add ```docker``` profile.
- Step 3: **\[Dockerization\]** Add ```Dockerfile```, ```setenv.sh``` and ```index-init.sh```.
- Step 4: Create Docker image
- Step 5: Test and Validation

## Step 1: Review and Correct Project Distribution Profile(s)

This recipe reuses and depends on your existing distribution Maven profile(s), assuming that the distribution tar ball, which is created by ```mvn -P dist``` profile (or a custom one similar to that), contains every artifacts for deployment, including ```conf/context.xml```, ```conf/log4j2.xml```, ```webapps/*.war```, ```common/lib/*.jar```, ```shared/lib/*.jar```, etc.

For the detailed layout of the standard distribution tar ball, please see the following page:

- [Create a Project Distribution](https://www.onehippo.org/library/development/create-a-project-distribution.html)

## Step 2: \[Dockerization\] Add ```docker``` profile

Add the following profile in the root pom.xml:

```xml
    <profile>
      <id>docker</id>
      <build>
        <plugins>
          <plugin>
            <groupId>com.spotify</groupId>
            <artifactId>dockerfile-maven-plugin</artifactId>
            <version>1.3.7</version>
            <executions>
              <execution>
                <id>default</id>
                <phase>validate</phase>
                <goals>
                  <goal>build</goal>
                  <!--
                  <goal>push</goal>
                  -->
                </goals>
              </execution>
            </executions>
            <configuration>
              <!-- Change repository name for your env. -->
              <repository>cms/${project.artifactId}</repository>
              <tag>${project.version}</tag>
              <buildArgs>
                <TAR_BALL>target/${project.artifactId}-${project.version}-distribution.tar.gz</TAR_BALL>
                <REPOSITORY_XML>src/main/tomcat/conf/repository.xml</REPOSITORY_XML>
                <SETENV_SH>src/main/tomcat/bin/setenv.sh</SETENV_SH>
                <INDEX_INIT_SH>src/main/tomcat/bin/index-init.sh</INDEX_INIT_SH>
              </buildArgs>
            </configuration>
          </plugin>
        </plugins>
      </build>
    </profile>
```

## Step 3: \[Dockerization\] Add ```Dockerfile```, ```repository.xml```, ```setenv.sh``` and ```index-init.sh```

### Copy [Dockerfile](examples/Dockerfile) to your project root folder, next to the root ```pom.xml```.

Review the **Environment Variable Configurations** section in the ```Dockerfile``` and adjust somethings if necessary for your environment.

### Add a repository.xml to be used in the Docker containers to ```src/main/tomcat/conf/``` folder in your project.

If you want to change the path for the repository configuration XML file, feel free to move it to somewhere else in your project, but update the ```REPOSITORY_XML``` build argument in the ```docker``` profile in the previous section accordingly.

**Note**: If you just want to extract the default ```repository.xml``` (using H2 database) which is used in local development environment with ```cargo.run``` profile, for testing purpose, then please download the default ```repository.xml``` from [https://code.onehippo.org/cms-community/hippo-repository/blob/master/resources/src/main/resources/org/hippoecm/repository/repository.xml](https://code.onehippo.org/cms-community/hippo-repository/blob/master/resources/src/main/resources/org/hippoecm/repository/repository.xml).

### Copy [setenv.sh](examples/setenv.sh) and [index-init.sh](examples/index-init.sh) to ```src/main/tomcat/bin/``` folder in your project.

If you want to change the path for the scripts, feel free to move those script files to somewhere else in your project, but update the ```SETENV_SH``` and ```INDEX_INIT_SH``` build arguments in the ```docker``` profile in the previous section accordingly.

**Note**: [setenv.sh](examples/setenv.sh) is responsible for checking and executing [index-init.sh](examples/index-init.sh), and [index-init.sh](examples/index-init.sh) is responsible for checking if the latest index export zip file is available and copying it to the local index directory if not existing on startup.

## Step 4: Create Docker image

After building and creating the distribution tar ball, execute ```mvn -P docker``` additionally like the following example:

```
$ mvn clean verify && mvn -P dist && mvn -P docker
```

## Step 5: Validation

You can run a container like the following example:

```bash
$ docker run --name myhippo --rm -p 8080:8080 "cms/myhippoproject:0.1.0-SNAPSHOT"
```

**Note**: Add ```-d``` option to start the container as detached.

Visit http://localhost:8080/site for delivery tier application, and visit http://localhost:8080/cms/ for authoring tier application, for example.

Check the startup logs with the following example command:

```bash
$ docker logs myhippo
```

You can browse all the files deployed, with the following example command:

```bash
$ docker exec myhippo find /usr/local/tomcat
```

## Useful Docker Documentation References

- [docker docs: Getting Started](https://docs.docker.com/get-started/)
- [docker docs: Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
- [docker docs: Command-Line Interfaces (CLIs)](https://docs.docker.com/engine/reference/commandline/docker/)
- [DevTools CLI Documentation: Docs: Common Tasks: SSH into a container](http://phase2.github.io/devtools/common-tasks/ssh-into-a-container/)
- [Experience Plugin: Lucene Index Export add-on](https://www.onehippo.org/library/enterprise/enterprise-features/lucene-index-export/lucene-index-export.html)
