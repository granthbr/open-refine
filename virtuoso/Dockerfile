FROM granthbr/virtuoso

ENV VIRT_HOME /opt/virtuoso-opensource
ENV VIRT_DB /opt/virtuoso-opensource/var/lib/virtuoso/db

RUN export PATH=$PATH:/opt/virtuoso-opensource/bin

EXPOSE 1111
EXPOSE 8890

WORKDIR /opt/virtuoso-opensource/var/lib/virtuoso/db
CMD ["opt/virtuoso-opensource/bin/virtuoso-t -f"]
