all:

MO_DIR = ../src/locale
DOMAIN = Visu2

pot:
	python xgettext.py $(DOMAIN).pot $(shell find ../.. -iname '*.as' -o -iname '*.mxml')

update-po:
	for po in *.po; do \
		lingua=`basename $$po .po`; \
		mv $$lingua.po $$lingua.old.po; \
		if msgmerge -o $$lingua.po $$lingua.old.po $(DOMAIN).pot; then\
		    rm $$lingua.old.po; \
		else \
		    rm -f $$lingua.po; \
		    mv $$lingua.old.po $$lingua.po; \
		fi \
	done

mo:
	for po in *.po; do\
		lingua=`basename $$po .po`; \
		install -d $(MO_DIR)/$$lingua/LC_MESSAGES/ ; \
		msgfmt -o $(MO_DIR)/$$lingua/LC_MESSAGES/$(DOMAIN).mo $$po ;\
	done

update: pot update-po

clean:
	-$(RM) $(DOMAIN).pot

