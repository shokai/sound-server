Sound Server
============
store sounds, encode, connect, generate

Install Dependencies
--------------------

    % brew install ffmpeg exiftool
    % gem install bundler
    % bundle install

Config
------

    % cp sample.config.yaml config.yaml

edit it.


Run
---

    % ruby development.ru

open [http://localhost:8080](http://localhost:8080)


Deploy
------
use Passenger with "config.ru"
