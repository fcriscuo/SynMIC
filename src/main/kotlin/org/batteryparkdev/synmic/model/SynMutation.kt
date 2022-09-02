package org.batteryparkdev.synmic.model

import org.apache.commons.csv.CSVRecord
import org.batteryparkdev.cosmicgraphdb.model.AbstractModel
import org.batteryparkdev.genomicgraphcore.common.*
import org.batteryparkdev.genomicgraphcore.neo4j.nodeidentifier.NodeIdentifier
import org.batteryparkdev.genomicgraphcore.neo4j.service.Neo4jConnectionService
import org.batteryparkdev.synmic.dao.SynMutationDao

data class RegRNA(
    val eseGain: Int, val eseLoss: Int, val essGain: Int, val essLoss: Int
) {
    companion object : AbstractModel {
        fun parseCSVRecord(record: CSVRecord): RegRNA =
            RegRNA(
                record.get("ESE Gain (RegRNA 2.0)").parseValidInteger(),
                record.get("ESE Loss (RegRNA 2.0)").parseValidInteger(),
                record.get("ESS Gain (RegRNA 2.0)").parseValidInteger(),
                record.get("ESS Loss (RegRNA 2.0)").parseValidInteger()
            )
    }
}

data class SpliceAidF(
    val eseGain: Int, val eseLoss: Int, val essGain: Int, val essLoss: Int,
    val eseAndEssGain: Int, val eseAndEssLoss: Int
) {
    companion object {
        fun parseCSVRecord(record: CSVRecord): SpliceAidF =
            SpliceAidF(
                record.get("ESE Gain (SpliceAidF)").parseValidInteger(),
                record.get("ESE Loss (SpliceAidF)").parseValidInteger(),
                record.get("ESS Gain (SpliceAidF)").parseValidInteger(),
                record.get("ESS Loss (SpliceAidF)").parseValidInteger(),
                record.get("ESE & ESS Gain (SpliceAidF)").parseValidInteger(),
                record.get("ESE & ESS Loss (SpliceAidF)").parseValidInteger()
            )
    }
}

data class SynMutation(
    val key: Int,   // unique key
    val geneName: String, val transcriptId: String, val mutationId: String,
    val ntMutation: String, val aaMutation: String, val mutationGenomePosition: String,
    val chromosome: String, val mutationStart: Int, val mutationEnd: Int, val strand: String,
    val signatureNormalizedFrequency: Double, val avgMutationLoad: Int,
    val alternativeEvents: String, val snp: String, val conservation: String,
    val structureChangeScore: String, val structureChangeSignificance: String,
    val synmicdbScore: Double, val sampleId: String, val organSystem: String,
    val site: String, val histology: String, val mutationLoadSample: Int,
    val positionInCDS: Float, val cgcGene: Boolean, val exonType: String,
    val distanceToExonBoundary: Int, val regRna: RegRNA, val spliceAidF: SpliceAidF,
    val anyEseEssChange: Int
) : CoreModel {

    override fun generateLoadModelCypher(): String = SynMutationDao(this).generateSynMutationCypher()
    // for SynMIC data, the geneName property is actually the HGNC gene symbol
    override fun getModelGeneSymbol(): String = geneName

    // The SynMICdb.csv file uses the heading "Sample ID" for what is really the sample name
    override fun getModelSampleId(): String =
        Neo4jConnectionService.executeCypherCommand(
            "MATCH (cs:CosmicSample{sample_name: ${sampleId.formatNeo4jPropertyValue()}} " +
                    "RETURN cs.sample_id")

    override fun getNodeIdentifier() = NodeIdentifier(
        "SynonymousMutation", "key",
        key.toString()
    )

    override fun getPubMedIds(): List<Int> = emptyList()

    override fun isValid(): Boolean =
        geneName.isNotEmpty().and(sampleId.isNotEmpty()).and(mutationId.isNotEmpty())
            .and(ntMutation.isNotEmpty())


    companion object : CoreModelCreator {
        val nodename = "synonymous_mutation"

        fun parseCsvRecord(record: CSVRecord): CoreModel =
            SynMutation(
                record.toString().hashCode(),
                record.get("Gene Name"),
                record.get("Transcript ID"),
                record.get("Mutation ID"),
                record.get("Mutation nt"),
                record.get("Mutation aa"),
                record.get("Mutation Genome Position"),
                record.get("Chromosome"),
                record.get("Start").parseValidInteger(),
                record.get("End").parseValidInteger(),
                record.get("Strand"),
                record.get("Signature-normalized Frequency").parseValidDouble(),
                record.get("Average Mutation Load").parseValidInteger(),
                record.get("Alternative Events"),
                record.get("SNP"),
                record.get("Conservation"),
                record.get("Structure Change Score (remuRNA)"),
                record.get("Structure Change Significance (RNAsnp)"),
                record.get("SynMICdb Score").parseValidDouble(),
                record.get("Sample ID"),
                record.get("Organ System"),
                record.get("Site"),
                record.get("Histology"),
                record.get("Mutation Load Sample").parseValidInteger(),
                record.get("Position in CDS").parseValidFloat(),
                record.get("CGC Gene").convertNumericToBoolean(),
                record.get("Exon Type"),
                record.get("Distance to Closest Exon Boundary").parseValidInteger(),
                RegRNA.parseCSVRecord(record),
                SpliceAidF.parseCSVRecord(record),
                record.get("Any ESE/ESS Change").parseValidInteger()
            )

        override val createCoreModelFunction: (CSVRecord) -> CoreModel = ::parseCsvRecord


    }
}
