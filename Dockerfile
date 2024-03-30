FROM tomcat:latest
RUN cp -R  /usr/local/tomcat/webapps.dist/*  /usr/local/tomcat/webapps
COPY /webapp/src/main/webapp/WEB-INF/*.xml /usr/local/tomcat/webapps

