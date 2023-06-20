# Użyj oficjalnego obrazu Ruby jako bazowego
FROM ruby:3.2.2


# Instaluje zależności systemowe
RUN apt-get update && apt-get install -y \
    build-essential \
    nodejs


# Instaluje Bundler
RUN gem install bundler


# Ustawia katalog roboczy wewnątrz kontenera
WORKDIR /app


# Kopiuje pliki Gemfile i Gemfile.lock
COPY Gemfile Gemfile.lock ./


# Instaluje zależności Rails
RUN bundle install


# Kopiuje resztę kodu źródłowego aplikacji
COPY . .


# Uruchom db:seed
RUN rails db:seed


# Uruchom serwer Ruby on Rails na porcie 3000
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
