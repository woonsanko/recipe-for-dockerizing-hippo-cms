# recipe-for-dockerizing-hippo-cms

## Introduction

TODO

## Dockerizing Your Hippo project

Add the following profile in the root pom.xml:

```
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

## Creating Docker Image

After building and creating the distribution tar ball, execute ```mvn -P docker``` additionally like the following:

```
$ mvn clean verify
$ mvn -P dist
$ mvn -P docker
```

