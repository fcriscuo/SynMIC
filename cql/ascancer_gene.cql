

:auto LOAD CSV WITH HEADERS FROM
'file:///Volumes/SSD870/SpecializedCancerDatasets/ASCancerAtlas/ASCancer_Gene_All.csv' AS line
CALL {
WITH line
WHERE line.id IS NOT NULL AND line.gene_name IS NOT NULL
MERGE (asc:ASCancer{asc_id:apoc.text.replace(line.id,"^\"|\"$","")})
SET asc.has_oncoprint = apoc.text.replace(line.has_oncoprint,"^\"|\"$",""),
  asc.event_id = apoc.text.replace(line.event_id,"^\"|\"$",""),
  asc.as_model_id = apoc.text.replace(line.as_model_id,"^\"|\"$",""),
  asc.as_cancer_name = apoc.text.replace(line.cancer_name,"^\"|\"$",""),
  asc.tcga_project_id = apoc.text.replace(line.tcga_project_id,"^\"|\"$",""),
  asc.gene_symbol = apoc.text.replace(line.gene_name,"^\"|\"$",""),
  asc.hgnc_id = apoc.text.join(['HGNC',apoc.text.replace(line.hgnc_id,"^\"|\"$","")],':'),
  asc.ensembl_id = apoc.text.replace(line.ensembl_id,"^\"|\"$",""),
  asc.ensembl_url = genomiccore.resolveEnsemblUrl(apoc.text.replace(line.ensembl_id,"^\"|\"$","")),
  asc.chromosome = apoc.text.replace(line.chr,"^\"|\"$",""),
  asc.strand = apoc.text.replace(line.strand,"^\"|\"$",""),
  asc.canonical_transcript_id = apoc.text.replace(line.canonical_transcript_id,"^\"|\"$",""),
  asc.canonical_transcript_description = apoc.text.replace(line.canonical_transcript_description,"^\"|\"$",""),
  asc.splice_variant_id = apoc.text.replace(line.splice_variant_id,"^\"|\"$",""),
  asc.sv_ensembl_id = apoc.text.replace(line.sv_ensembl_id,"^\"|\"$",""),
  asc.sv_refSeq_id = apoc.text.replace(line.sv_refSeq_id,"^\"|\"$",""),
  asc.splice_variant_description = apoc.text.replace(line.splice_variant_description,"^\"|\"$",""),
  asc.as_type = apoc.text.replace(line.as_type,"^\"|\"$",""),
  asc.related_exons = split(apoc.text.replace(line.related_exons,"^\"|\"$",""),','),
  asc.exon_ensembl_id = apoc.text.replace(line.exon_ensembl_id,"^\"|\"$",""),
  asc.event_coordinates =  split(apoc.text.replace(line.event_coordinates,"^\"|\"$",""),','),
  asc.alt_coordinates =  split(apoc.text.replace(line.alt_coordinates,"^\"|\"$",""),','),
  asc.splice_in_isoforms =  split(apoc.text.replace(line.splice_in_isoforms,"^\"|\"$",""),','),
  asc.splice_out_isoforms =  split(apoc.text.replace(line.splice_out_isoforms,"^\"|\"$",""),','),
  asc.orf_annotation = apoc.text.replace(line.orf_annotation,"^\"|\"$",""),
  asc.primer_f = apoc.text.replace(line.primer_f,"^\"|\"$",""),
  asc.primer_r = apoc.text.replace(line.primer_r,"^\"|\"$",""),
  asc.cell_lines = split(apoc.text.replace(line.cell_line,"^\"|\"$",""),','),
  asc.primary_site = apoc.text.replace(line.primary_site,"^\"|\"$",""),
  asc.samples =  apoc.text.replace(line.samples,"^\"|\"$",""),
  asc.methods =  split(apoc.text.replace(line.methods,"^\"|\"$",""),','),
  asc.external_intervention = apoc.text.replace(line.external_intervention,"^\"|\"$",""),
  asc.regulatory_mechanism = apoc.text.replace(line.regulatory_mechanism,"^\"|\"$",""),
  asc.regulatory_genes = split(apoc.text.replace(line.regulatory_gene,"^\"|\"$",""),','),
  asc.biological_functions = split(apoc.text.replace(line.biological_function,"^\"|\"$",""),','),
  asc.functional_description = apoc.text.replace(line.functional_description,"^\"|\"$",""),
  asc.year = toInteger(apoc.text.replace(line.year,"^\"|\"$","")),
  asc.pub_id = toInteger(apoc.text.replace(line.pubmed_id,"^\"|\"$","")),
  asc.journal = apoc.text.replace(line.journal,"^\"|\"$",""),
  asc.title = apoc.text.replace(line.title,"^\"|\"$",""),
  asc.date_created = datetime()
} IN TRANSACTIONS OF 1000 ROWS;

// ASCancer relationship to EntrezGene
MATCH (asc:ASCancer) WHERE asc.gene_symbol IS NOT NULL
MATCH (eg:EntrezGene) WHERE eg.gene_symbol = asc.gene_symbol
MERGE (asc)-[r1:HAS_ENTREZ_GENE]->(eg)
;
// CosmicGene relationship to ASCancer event
MATCH (asc:ASCancer) WHERE asc.gene_symbol IS NOT NULL
MATCH(cg:CosmicGene) WHERE cg.gene_symbol = asc.gene_symbol
MERGE (cg)-[r2:HAS_HAS_ALT_SPLICE_CANCER_EVENT]->(asc)
;

// ASCancer to Publication relationship
// since ASCancer is a primary source, ensure that the PubMed label is
// added to the Publication node
MATCH (asc:ASCancer) WHERE asc.pub_id IS NOT NULL
MERGE (p:Publication{pub_id:asc.pub_id})
ON CREATE
SET p.url= genomiccore.resolvePubmedUrl(toString(p.pub_id)),
p.needs_properties=true,
p.needs_references=true
MERGE (asc)-[r3:HAS_PUBLICATION]->(p)
WITH p
CALL apoc.create.addLabels(p,["PubMed"]) YIELD node RETURN node LIMIT 1
;