CONTRIB_DIR = .
TEST_DIR = ./tests
LLQUEUE_DIR = $(CONTRIB_DIR)/CLinkedListQueue

GCOV_OUTPUT = *.gcda *.gcno *.gcov 
GCOV_CCFLAGS = -fprofile-arcs -ftest-coverage
SHELL  = /bin/bash
CC     = g++
CCFLAGS = -g -O0 $(GCOV_CCFLAGS) -I$(LLQUEUE_DIR) -I./ -w -fpermissive -fno-inline-functions #-fno-omit-frame-pointer -fno-common -fsigned-char
SRCS = state_mach.cpp raft_server.cpp raft_logger.cpp raft_node.cpp $(TEST_DIR)/main_test.c $(TEST_DIR)/test_server.c $(TEST_DIR)/test_node.c $(TEST_DIR)/test_log.c $(TEST_DIR)/test_scenario.c $(TEST_DIR)/mock_send_functions.c $(TEST_DIR)/CuTest.c $(LLQUEUE_DIR)/linked_list_queue.c

all: tests_main

download-contrib:
	git submodule update CLinkedListQueue

$(TEST_DIR)/main_test.c:
	if test -d $(LLQUEUE_DIR); \
	then echo have contribs; \
	else make download-contrib; \
	fi
	cd $(TEST_DIR) && sh make-tests.sh "test_*.c" > main_test.c && cd ..

tests_main: $(SRCS)
	$(CC) $(CCFLAGS) -o $@ $^
	./tests_main

clean:
	rm -f $(TEST_DIR)/main_test.c *.o $(GCOV_OUTPUT)
