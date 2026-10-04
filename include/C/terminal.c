#include <VGA.h>
#include <string.h>
#include <terminal.h>
#include <stdint.h>

void terminal_initialize(void) {
	terminal_row = 0;
	terminal_column = 0;
	terminal_color = vga_entry_color(VGA_COLOR_LIGHT_GREY, VGA_COLOR_BLACK);
	video_memory = (uint16_t *)0xb8000;
	for (size_t y = 0; y < VGA_HEIGHT; y++) {
		for (size_t x = 0; x < VGA_WIDTH; x++) {
			const size_t index = y * VGA_WIDTH + x;
			video_memory[index] = vga_entry(' ', terminal_color);
		}
	}
}

void terminal_clear(void) {
	terminal_row = 0;
	terminal_column = 0;
	for (size_t y = 0; y < VGA_HEIGHT; y++) {
		for (size_t x = 0; x < VGA_WIDTH; x++) {
			const size_t index = x + y * VGA_WIDTH;
			video_memory[index] = vga_entry(' ', terminal_color);
		}
	}
}

void terminal_setcolor(uint8_t color) {
	terminal_color = color;
}

void terminal_putentryat(char c, uint8_t color, size_t x, size_t y) {
	const size_t index = y * VGA_WIDTH + x;
	video_memory[index] = vga_entry(c, color);
}

void terminal_scroll() {
	for (size_t y = 0; y < VGA_HEIGHT; y++) {
		for (size_t x = 0; x < VGA_WIDTH; x++) {
			const size_t index1 = x + (y+1) * VGA_WIDTH;
			const size_t index2 = x + y * VGA_WIDTH;
			video_memory[index2] = video_memory[index1];
		}
	}
}

void terminal_putchar(char c) {
	if (c == '\n') {
		terminal_row++;
		terminal_column = -1;
	} else {
		terminal_putentryat(c, terminal_color, terminal_column, terminal_row);
	}

	if (++terminal_column == VGA_WIDTH) {
		terminal_column = 0;
		terminal_row++;
	}

	if (terminal_row == VGA_HEIGHT) {
		terminal_scroll();
		terminal_row = VGA_HEIGHT - 1;
	}
}

void terminal_write(const char *data, size_t size) {
	for (size_t i = 0; i < size; i++) {
		terminal_putchar(data[i]);
	}
}

void terminal_writestring(const char *data) {
	terminal_write(data, strlen(data));
}
