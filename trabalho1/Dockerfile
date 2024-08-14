FROM tleemcjr/metasploitable2:latest

WORKDIR /app

COPY scanner.c /app/
COPY Makefile /app/
COPY scanner.sh /app/

RUN chmod +x /app/scanner.sh

CMD ["/app/scanner.sh"]