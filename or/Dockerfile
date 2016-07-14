FROM ubuntu:trusty
MAINTAINER Brandon Grantham <brandon.grantham@gmail.com>
# Add install script and build OpenRefine inside of the container. 
# Change from original, merge RUN commands as reccomended by Docker for less layered images. 
ADD install-refine.sh install-refine.sh
RUN chmod +x install-refine.sh && \
     ./install-refine.sh
ENV JAVA_OPTIONS='-XX:PermSize=512m -XX:MaxPermSize=512m'

EXPOSE 3333

CMD ["/start.sh"]
