# Recipe for Dockerizing Hippo CMS

## Introduction

TODO

## Steps Overview

- Step 1: **\[Dockerization\]** Add ```docker``` profile.
- Step 2: **\[Dockerization\]** Add ```Dockerfile```.
- Step 3: Create Docker image
- Step 4: Test and Validation

## Step 1: \[Dockerization\] Add ```docker``` profile

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
              <repository>cms/${project.artifactId}</repository>
              <tag>${project.version}</tag>
              <buildArgs>
                <TAR_BALL>target/${project.artifactId}-${project.version}-distribution.tar.gz</TAR_BALL>
              </buildArgs>
            </configuration>
          </plugin>
        </plugins>
      </build>
    </profile>
```

## Step 2: \[Dockerization\] Add ```Dockerfile``` 

Copy [Dockerfile](examples/Dockerfile) to your project root folder, next to the root ```pom.xml```.

Review the **Environment Variable Configurations** section in the ```Dockerfile``` and adjust somethings if necessary for your environment.

## Step 3: Create Docker image

After building and creating the distribution tar ball, execute ```mvn -P docker``` additionally like the following:

```
$ mvn clean verify
$ mvn -P dist
$ mvn -P docker
```

## Step 4: Validation

TODO
