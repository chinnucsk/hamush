SRC_DIR=src
BIN_DIR=ebin
DOC_DIR=doc
CC=erlc
ERL=erl
CC_FLAGS=+debug_info -I include
RUN_FLAGS=
BEAMS=ebin/ham_app.beam ebin/mcon_sup.beam ebin/mcon_con_sup.beam ebin/mcon_listener.beam ebin/mcon_connection.beam ebin/hamush.beam ebin/cmds_interaction.beam ebin/cmds_movement.beam ebin/cmds_initial.beam ebin/cmds_creation.beam ebin/ham_sup.beam ebin/ham_lisp.beam ebin/ham_fun_storage.beam ebin/fun_core.beam ebin/fun_communication.beam ebin/fun_lists.beam ebin/fun_privileged.beam ebin/mushdb.beam ebin/mdb_app.beam ebin/mdb_element.beam ebin/mdb_event.beam ebin/mdb_store.beam ebin/mdb_store_sup.beam ebin/mdb_sup.beam ebin/mcmd_app.beam ebin/mcmd_cmd_storage.beam ebin/mcmd_sup.beam ebin/mcmd_worker.beam ebin/mcmd_worker_sup.beam ebin/mushcmd.beam
PROJECT=hamush



all: $(BEAMS)

clean: 
	-rm $(BIN_DIR)/*.beam $(DOC_DIR)/*

ebin/%.beam: src/%.erl
	$(CC) $(CC_FLAGS) -o $(BIN_DIR) $<

run: #all
	$(ERL) $(RUN_FLAGS) -pa $(BIN_DIR) -eval "toolbar:start(), application:start(sasl), application:start($(PROJECT))."

doc:
	$(ERL) -eval 'edoc:application($(PROJECT), "", []).'
