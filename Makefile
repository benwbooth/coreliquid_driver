CC = gcc
CFLAGS = -Wall -Wextra -O2
LDFLAGS = -lhidapi-hidraw -lsensors

SRC_DIR = src
BUILD_DIR = build
TARGET = $(BUILD_DIR)/my_msi_driver

SRCS = $(SRC_DIR)/my_msi_driver.c

PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin
SYSTEMD_DIR = /etc/systemd/system

.PHONY: all clean install uninstall install-service

all: $(TARGET)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(TARGET): $(SRCS) | $(BUILD_DIR)
	$(CC) $(CFLAGS) $< $(LDFLAGS) -o $@

clean:
	rm -rf $(BUILD_DIR)

install: $(TARGET)
	install -Dm755 $(TARGET) $(DESTDIR)$(BINDIR)/my_msi_driver

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/my_msi_driver

install-service: install
	install -Dm644 my_msi_driver.service $(DESTDIR)$(SYSTEMD_DIR)/my_msi_driver.service
	install -Dm644 my_msi_driver-resume.service $(DESTDIR)$(SYSTEMD_DIR)/my_msi_driver-resume.service
	systemctl daemon-reload
