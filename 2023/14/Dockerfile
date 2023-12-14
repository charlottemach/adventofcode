FROM r-base:4.3.2

WORKDIR /app
COPY . /app

RUN R -e 'install.packages("digest")'

CMD ["Rscript", "fourteen.R"]
