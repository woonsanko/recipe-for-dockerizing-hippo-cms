# Recipe for Dockerizing Hippo CMS

## Introduction

TODO

## Steps Overview

- Step 1: Review and Correct Project Distribution Profile.
- Step 2: **\[Dockerization\]** Add ```docker``` profile.
- Step 3: **\[Dockerization\]** Add ```Dockerfile```.
- Step 4: Create Docker image
- Step 5: Test and Validation

## Step 1: Review and Correct Project Distribution Profile

This recipe assumes that the distribution tar ball, which is created by ```mvn -P dist``` profile (or a custom one similar to that), contains every files for deployment, including ```conf/repository.xml```, ```conf/context.xml```, ```conf/log4j2.xml```, ```webapps/*.war```, ```common/lib/*.jar``` and ```shared/lib/*.jar``` files.

Therefore, please make sure your distribution profile (```mvn -P dist``` by default, or a custom one if necessary) contains everything necessary. For example, ```conf/repository.xml``` is not included by default for local development environment.

If you just want to extract the default ```repository.xml``` used in local development environment with using H2 database, just for testing, then please download it from [https://code.onehippo.org/cms-community/hippo-repository/blob/master/resources/src/main/resources/org/hippoecm/repository/repository.xml](https://code.onehippo.org/cms-community/hippo-repository/blob/master/resources/src/main/resources/org/hippoecm/repository/repository.xml) to ```conf/repository.xml```.

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
              </buildArgs>
            </configuration>
          </plugin>
        </plugins>
      </build>
    </profile>
```

## Step 3: \[Dockerization\] Add ```Dockerfile``` 

Copy [Dockerfile](examples/Dockerfile) to your project root folder, next to the root ```pom.xml```.

Review the **Environment Variable Configurations** section in the ```Dockerfile``` and adjust somethings if necessary for your environment.

## Step 4: Create Docker image

After building and creating the distribution tar ball, execute ```mvn -P docker``` additionally like the following example:

```
$ mvn clean verify && mvn -P dist && mvn -P docker
```

## Step 5: Validation

```bash
$ docker run -p 8080:8080 <image>
```

