package org.batteryparkdev.synmic.model

import org.apache.commons.csv.CSVRecord
import org.batteryparkdev.cosmicgraphdb.model.AbstractModel
import org.batteryparkdev.cosmicgraphdb.model.CosmicModel
import org.batteryparkdev.nodeidentifier.model.NodeIdentifier

/*
CSV column headings:
"Gene Name","Transcript ID","Mutation ID","Mutation nt","Mutation aa","Mutation Genome Position",
"Chromosome","Start","End","Strand","Signature-normalized Frequency","Average Mutation Load",
"Alternative Events","SNP","Conservation","Structure Change Score (remuRNA)",
"Structure Change Significance (RNAsnp)","SynMICdb Score","Sample ID","Organ System",
"Site","Histology","Mutation Load Sample","Position in CDS","CGC Gene","Exon Type",
"Distance to Closest Exon Boundary","ESE Gain (RegRNA 2.0)","ESE Loss (RegRNA 2.0)",
"ESS Gain (RegRNA 2.0)","ESS Loss (RegRNA 2.0)","ESE Gain (SpliceAidF)","ESE Loss (SpliceAidF)",
"ESS Gain (SpliceAidF)","ESS Loss (SpliceAidF)","ESE & ESS Gain (SpliceAidF)",
"ESE & ESS Loss (SpliceAidF)","Any ESE/ESS Change"
*/


data class RegRNA(
    val eseGain: Int, val eseLoss: Int, val essGain: Int, val essLoss: Int
){
    companion object:AbstractModel {
        fun parseCSVRecord(record: CSVRecord): RegRNA =
            RegRNA(
                parseValidIntegerFromString(record.get("ESE Gain (RegRNA 2.0)")),
                parseValidIntegerFromString(record.get("ESE Loss (RegRNA 2.0)")),
                parseValidIntegerFromString(record.get("ESS Gain (RegRNA 2.0)")),
                parseValidIntegerFromString(record.get("ESS Loss (RegRNA 2.0)"))
            )
    }
}

data class SpliceAidF(
    val eseGain: Int, val eseLoss: Int, val essGain: Int, val essLoss: Int,
    val eseAndEssGain: Int, val eseAndEssLoss: Int
) {
    companion object: AbstractModel {
        fun parseCSVRecord(record: CSVRecord): SpliceAidF =
            SpliceAidF(
                parseValidIntegerFromString(record.get("ESE Gain (SpliceAidF)")),
                parseValidIntegerFromString(record.get("ESE Loss (SpliceAidF)")),
                parseValidIntegerFromString(record.get("ESS Gain (SpliceAidF)")),
                parseValidIntegerFromString(record.get("ESS Loss (SpliceAidF)")),
                parseValidIntegerFromString(record.get("ESE & ESS Gain (SpliceAidF)")),
                parseValidIntegerFromString(record.get("ESE & ESS Loss (SpliceAidF)"))
            )
    }
}

data class SynMutation(
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
) : CosmicModel {
    override fun generateLoadCosmicModelCypher(): String {
        TODO("Not yet implemented")
    }

    override fun getNodeIdentifier(): NodeIdentifier {
        TODO("Not yet implemented")
    }

    override fun getPubMedId(): Int = 0

    override fun isValid(): Boolean {
        TODO("Not yet implemented")
    }

    companion object : AbstractModel {
        fun parseCSVRecord(record: CSVRecord): SynMutation =
            SynMutation(
                record.get("Gene Name"),
                record.get("Transcript ID"),
                record.get("Mutation ID"),
                record.get("Mutation nt"),
                record.get("Mutation aa"),
                record.get("Mutation Genome Position"),
                record.get("Chromosome"),
                parseValidIntegerFromString(record.get("Start")),
                parseValidIntegerFromString(record.get("End")),
                record.get("Strand"),
                parseValidDoubleFromString(record.get("Signature-normalized Frequency")),
                parseValidIntegerFromString(record.get("Average Mutation Load")),
                record.get("Alternative Events"),
                record.get("SNP"),
                record.get("Conservation"),
                record.get("Structure Change Score (remuRNA)"),
                record.get("Structure Change Significance (RNAsnp)"),
                parseValidDoubleFromString(record.get("SynMICdb Score")),
                record.get("Sample ID"),
                record.get("Organ System"),
                record.get("Site"),
                record.get("Histology"),
                parseValidIntegerFromString(record.get("Mutation Load Sample")),
                parseValidFloatFromString(record.get("Position in CDS")),
                convertNumericToBoolean(record.get("CGC Gene")),
                record.get("Exon Type"),
                parseValidIntegerFromString(record.get("Distance to Closest Exon Boundary")),
                RegRNA.parseCSVRecord(record),
                SpliceAidF.parseCSVRecord(record),
                parseValidIntegerFromString(record.get("Any ESE/ESS Change"))
            )

        fun convertNumericToBoolean(value: String): Boolean = value == "1"
    }
}
