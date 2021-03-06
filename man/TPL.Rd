\name{TPL}
\alias{TPL}
\title{
Connection to The Plant List (TPL) website to check for the validity of a list of plant names
}
\description{
Connects to TPL and validates the name of a vector of plant species names, replacing synonyms to accepted names and removing orthographical errors in plant names
}
\usage{
TPL(splist, genus = NULL, species = NULL, infrasp = NULL, infra = TRUE, abbrev = TRUE, 
corr = TRUE, diffchar = 2, max.distance = 1, version = "1.1", encoding = "UTF-8",
file = "")
}
\arguments{
  \item{splist}{
A vector of plant names, each element including the genus and specific epithet and, additionally, the infraspecific epithet.
}
  \item{genus}{
A vector containing the genera for plant species names.
}
  \item{species}{
A vector containing the specific epithets for plant species names.
}
  \item{infrasp}{
A vector containing the infraspecific epithets for plant species names (i.e. varieties and subspecies).
}
  \item{infra}{
Logical. If 'TRUE' (default) then infraspecific epithets are used to validate the taxonomic status of species names in TPL.
}
  \item{abbrev}{
Logical. If 'TRUE' (default), abbreviations (aff., cf., subsp., var.) and their variants are removed prior to taxonomic standardization.
}
  \item{corr}{
Logical. If 'TRUE' (default), then removal of orthographical errors is performed (only) on specific and infraspecific epithets prior to taxonomic standardization.
}
  \item{diffchar}{
A number indicating the maximum difference between number of characters in corrected and original species names. Not used if corr=FALSE.
}
  \item{max.distance}{
Maximum distance allowed for a match in \code{agrep} function when performing corrections of orthographical errors in specific epithets. Not used if corr=FALSE.
}
  \item{version}{
A character indicating whether to connect to the newest version of TPL (1.1) or to the older one (1.0). Defaults to "1.1".
}
  \item{encoding}{
Encoding to be assumed for input strings.  It is used to mark character strings as known to be in Latin-1 or UTF-8 (see 'Encoding'). It is not used to re-encode the input, but allows R to handle encoded strings in their native encoding (if one of those two). Defaults to "UTF-8" but it can be changed to "unknown" or "Latin-1".
}
  \item{file}{
Either a character string naming a file or a connection open for writing. "" (default) indicates output to the console.
}
}
\details{
The procedure used for taxonomic standardization is based on function \code{TPLck}. If 'infra=FALSE', then infraspecific epithets are neither considered for species name validation in TPL, nor returned in the output.
}
\value{
The function return an object of class \code{data.frame} with the following components:

\item{$Genus }{Original genus of species provided as input for taxonomic standardization.}
\item{$Species }{Original specific epithet of species provided as input for taxonomic standardization.}
\item{$Abbrev }{Standard annotation used in species epithet, including "cf.", "aff.", "s.l.", and "s.str." and their orthographic variants.}
\item{$Infraspecific }{Original intraspecific epithet of species provided as input for taxonomic standardization. If 'infra=FALSE', this is not shown. }
\item{$ID }{ The Plant List record 'id'.}
\item{$Plant.Name.Index }{Logical. If 'TRUE' the name is in TPL.}
\item{$Taxonomic.status}{Taxonomic status as in TPL, either 'Accepted', 'Synonym', 'Unresolved', or 'Misapplied'.}
\item{$TPL_version}{Version of TPL used.}
\item{$Family }{Family name, extracted from TPL for the valid form of the name.}
\item{$New.Genus }{Genus, extracted from TPL for the valid form of the name.}
\item{$New.Hybrid.marker }{Hybrid marker, extracted from TPL for the valid form of the name.}
\item{$New.Species }{Specific epithet, extracted from TPL for the valid form of the name.}
\item{$New.Infraspecific }{Infraspecific epithet, extracted from TPL for the valid form of the name.}
\item{$Authority }{A field designating the scientist(s) who first published the name, extracted from TPL for the valid form of the name.}
\item{$New.ID }{The Plant List record 'id' for the species name, once synonyms have been replaced by accepted names. In all other cases, this field will be equivalent to 'ID'.}
\item{$Typo }{Logical. If 'TRUE' there was a spelling error in the specific epithet that has been corrected.}
\item{$WFormat }{Logical. If 'TRUE', fields in TPL had the wrong format for information to be automatically extracted as they were not properly tabulated or, alternatively, there was not a unique solutions (see 'note').}
}
\references{
Cayuela, L., Granzow-de la Cerda, I., Albuquerque, F.S. and Golicher, J.D. 2012. Taxonstand: An R package for species names standardisation in vegetation databases. \emph{Methods in Ecology and Evolution}, 3(6): 1078-1083.

Kalwij, J.M. 2012. Review of 'The Plant List, a working list of all plant species'. \emph{Journal of Vegetation Science}, 23(5): 998-1002.

}
\author{
Luis Cayuela
}
\note{
Various limitations have been identified to date in the implementation of this function. First, homonyms (i.e. names orthographically identical but applied to different taxa) cannot be flagged. Second, if the infraspecific epithet in the input does not match any of the infraspecific epithets provided by TPL, then the first accepted name without infraspecific epithets will be selected as the best match. If all names provided by TPL bear infraspecific epithets but are all synonyms (e.g. \emph{Pottia starkeana}), then none is considered as a best match and the output will return the original name in the input.

In addition, some users have experienced problems when using Taxonstand version 1.3, particularly under Windows O.S. This problem arises from differences in the encoding system used by the server and the client, which results in the following error message:

Error in file(con, "r") : cannot open the connection
In addition: Warning message:
In file(con, "r") : cannot open: HTTP status was '404 Not Found'

The code has been fixed to avoid this issue when retrieving data from The Plant List. Nonetheless, if users keep experiencing the same problem, please report it to the maintainer."
}

\seealso{
See also \code{\link{TPLck}}.
}
\examples{
  \dontrun{
data(bryophytes)

# Species names in full
r1 <- TPL(bryophytes$Full.name[1:20], corr=TRUE)
str(r1)

# A separate specification for genera, specific, and infraspecific epithets 
r2 <- TPL(genus = bryophytes$Genus, species = bryophytes$Species, 
infrasp = bryophytes$Intraspecific, corr=TRUE)
str(r2)

####################################
### An example using data from GBIF
####################################
require(dismo)
# Download data containing all records available in GBIF of all species 
# within genus Oreopanax (GBIF table)
oreopanax <- gbif("Oreopanax", "*", geo=T)
# But a list of species can be also downloaded from GBIF for a defined geographical area

# Names downloaded from GBIF often include the authority. 
# The column names need to be split using the spaces as the split. 
# This will result in multiple columns. We essentially only need the first two columns.
sp.list <- do.call("rbind", strsplit(oreopanax$species, split=" "))
sp.list <- as.factor(paste(sp.list[,1], sp.list[,2]))

# Perform taxonomic standardisation on plant names list (TPL table)
sp.check <- TPL(levels(sp.list), infra=FALSE, corr=TRUE)
head(sp.check)

# Bind GBIF table with TPL table
oreopanax$id <- as.numeric(sp.list)
sp.check$id <- 1:dim(sp.check)[1]
oreopanax.check <- merge(oreopanax, sp.check, by="id", all=T)
}
}
\keyword{ vegetation analysis }
