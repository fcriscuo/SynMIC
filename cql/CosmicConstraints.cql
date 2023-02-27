CREATE CONSTRAINT unique_asc_id IF NOT EXISTS FOR (asc:ASCancer) REQUIRE asc.asc_id IS UNIQUE

CREATE INDEX synmut_gene_symbol_index FOR (syn:SynonymousMutation) ON (syn.gene_symbol)
