
CREATE TABLE producer (
    producer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);

CREATE TABLE movie (
    movie_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100),
    year INT,
    rating VARCHAR(10),
    producer_id INT,
    FOREIGN KEY (producer_id) REFERENCES producer(producer_id)
);

CREATE TABLE actor (
    actor_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);

CREATE TABLE movie_actor (
    movie_id INT,
    actor_id INT,
    role_type VARCHAR(20),
    payment_amount DECIMAL(10,2),
    PRIMARY KEY (movie_id, actor_id),
    FOREIGN KEY (movie_id) REFERENCES movie(movie_id),
    FOREIGN KEY (actor_id) REFERENCES actor(actor_id)
);

CREATE TABLE theatre (
    theatre_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    address VARCHAR(200),
    ticket_price DECIMAL(6,2)
);

CREATE TABLE movie_theatre (
    movie_id INT,
    theatre_id INT,
    tickets_sold INT,
    PRIMARY KEY (movie_id, theatre_id),
    FOREIGN KEY (movie_id) REFERENCES movie(movie_id),
    FOREIGN KEY (theatre_id) REFERENCES theatre(theatre_id)
);
