DROP DATABASE IF EXISTS event_calendar;
CREATE DATABASE event_calendar;
USE event_calendar;

DROP TABLE IF EXISTS RECURRING_EVENT_SUFFIX;
DROP TABLE IF EXISTS RECURRING_EVENT;
DROP TABLE IF EXISTS ATTENDANCE_RECORD;
DROP TABLE IF EXISTS EVENT_SCHEDULE_ITEM;
DROP TABLE IF EXISTS EVENT;
DROP TABLE IF EXISTS USER;

CREATE TABLE USER(
                     userId INT NOT NULL AUTO_INCREMENT,
                     firstName VARCHAR(100) NOT NULL,
                     lastName VARCHAR(100) NOT NULL,
                     isAdmin BOOLEAN NOT NULL,
                     email VARCHAR(100) NOT NULL,
                     password VARCHAR(100) NOT NULL,
                     PRIMARY KEY (userId),
                     UNIQUE (email)
);

CREATE TABLE EVENT(
                      eventId INT NOT NULL AUTO_INCREMENT,
                      title VARCHAR(100) NOT NULL,
                      location VARCHAR(100) NOT NULL,
                      startDate DATETIME NOT NULL,
                      endDate DATETIME NOT NULL,
                      description VARCHAR(1000) NOT NULL,
                      PRIMARY KEY (eventId),
                      CONSTRAINT chk_start_end_time CHECK (startDate <= endDate),
                      CONSTRAINT uc_event_time_location UNIQUE (location, startDate, endDate)
);

CREATE TABLE ATTENDANCE_RECORD(
                                  attendanceId INT NOT NULL AUTO_INCREMENT,
                                  userId INT NOT NULL,
                                  eventId INT NOT NULL,
                                  PRIMARY KEY (attendanceId),
                                  FOREIGN KEY (userId) REFERENCES USER(userId) ON DELETE CASCADE,
                                  FOREIGN KEY (eventId) REFERENCES EVENT(eventId) ON DELETE CASCADE
);

CREATE TABLE EVENT_SCHEDULE_ITEM(
                                    scheduleItemId INT NOT NULL AUTO_INCREMENT,
                                    eventId INT NOT NULL,
                                    startDate DATETIME NOT NULL,
                                    endDate DATETIME NOT NULL,
                                    activity VARCHAR(100) NOT NULL,
                                    description VARCHAR(1000) NOT NULL,
                                    PRIMARY KEY (scheduleItemId),
                                    FOREIGN KEY (eventId) REFERENCES EVENT(eventId)
);

CREATE TABLE RECURRING_EVENT_SUFFIX(
                                       recurringEventSuffixId INT NOT NULL AUTO_INCREMENT,
                                       eventId INT NOT NULL,
                                       type VARCHAR(20) NOT NULL,
                                       endRecurringDate DATETIME NOT NULL,
                                       PRIMARY KEY (recurringEventSuffixId),
                                       FOREIGN KEY (eventId) REFERENCES EVENT(eventId) ON DELETE CASCADE
);

CREATE TABLE RECURRING_EVENT(
                                recurringEventId INT NOT NULL AUTO_INCREMENT,
                                recurringEventSuffixId INT NOT NULL,
                                startDate DATETIME NOT NULL,
                                endDate DATETIME NOT NULL,
                                PRIMARY KEY (recurringEventId),
                                FOREIGN KEY (recurringEventSuffixId) REFERENCES RECURRING_EVENT_SUFFIX(recurringEventSuffixId) ON DELETE CASCADE
);
