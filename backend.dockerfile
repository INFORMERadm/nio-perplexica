FROM nikolaik/python-nodejs:python3.12-nodejs20.19.1-bullseye

ARG SEARXNG_API_URL

# Install build dependencies
RUN apt-get update && apt-get install -y build-essential python3

WORKDIR /home/perplexica

COPY src /home/perplexica/src
COPY tsconfig.json /home/perplexica/
COPY config.toml /home/perplexica/
COPY drizzle.config.ts /home/perplexica/
COPY package.json /home/perplexica/
COPY yarn.lock /home/perplexica/

RUN sed -i "s|SEARXNG = \".*\"|SEARXNG = \"${SEARXNG_API_URL}\"|g" /home/perplexica/config.toml

RUN mkdir /home/perplexica/data

# Clean install and rebuild better-sqlite3
RUN yarn cache clean && \
    yarn install --force && \
    yarn rebuild better-sqlite3

RUN yarn build

CMD ["yarn", "start"]