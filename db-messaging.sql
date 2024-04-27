CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    phone_number VARCHAR(255) UNIQUE NOT NULL,
    display_name VARCHAR(255),
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(100) CHECK (role IN ('admin', 'member')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE groups (
    group_id SERIAL PRIMARY KEY,
    group_name VARCHAR(255) NOT NULL,
    created_by INT NOT NULL REFERENCES users(user_id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE group_members (
    group_id INT NOT NULL REFERENCES groups(group_id),
    user_id INT NOT NULL REFERENCES users(user_id),
    role VARCHAR(100) CHECK (role IN ('admin', 'member')),
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (group_id, user_id)
);

CREATE TABLE messages (
    message_id SERIAL PRIMARY KEY,
    sender_id INT NOT NULL REFERENCES users(user_id),
    content TEXT,
    message_type VARCHAR(100) CHECK (message_type IN ('text', 'image', 'file')),
    file_path VARCHAR(255), -- Path for image/file storage
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE message_recipients (
    message_id INT NOT NULL REFERENCES messages(message_id),
    recipient_user_id INT REFERENCES users(user_id),
    recipient_group_id INT REFERENCES groups(group_id),
    status VARCHAR(100) CHECK (status IN ('read', 'sent', 'pending')),
    read_at TIMESTAMP WITH TIME ZONE,
    PRIMARY KEY (message_id, recipient_user_id, recipient_group_id),
    CHECK ((recipient_user_id IS NOT NULL AND recipient_group_id IS NULL) OR
           (recipient_user_id IS NULL AND recipient_group_id IS NOT NULL))
);
