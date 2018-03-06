#' Read landmark data from a shapes object (StereoMorph)
#'
#' Read data from an object with class shapes, created by StereoMorph
#'
#' This function reads data from an object with class "shapes", after digitizing specimens using StereoMorph.
#' This function can read in landmarks plus acquire points from curves, if the curves option was used in digitizing.
#' This function is intended for reading data and facilitating the generation of a "curves" matrix for \code{\link{gpagen}}.
#' It is not intended to influence how one should digitize landmarks using StereoMorph.  Each digitizing experience is
#' unique and users might need to edit their own data using StereoMorph functions in some cases; this function will not
#' necessarily overcome all data editing challenges.  This function currently works with 2D data only, 
#' as the readShapes function of StereMorph pertains to digitizing images.
#' 
#' The enhanced feature of this function is that it can find a prescribed number of approximatey equally spaced 
#' semilandmarks along 2D curves (from the many points of Bexier curves in StereoMorph), facilitating rapid \code{\link{gpagen}}
#' analysis and the flexibility to change the desired number of semilandmarks defining curves.  This is only true, however,
#' if the curves oprtion in digitizeImages (StreoMorph) is used.  
#' 
#' The user can specify the number of points along curves, whether curves are continuous (closed and without fixed points), 
#' and whether landmarks should be scaled, if possible (if scaling was performed while digtizing).
#'
#' @param Shapes An object with class, "shapes"
#' @param nCurvePts A single value (if only one curve) or a string of values (if multiple curves) for culling the number of
#' curve points, using linear interpolation to find equally spaced distances between points.  For example, with three curves,
#' nCurvePts = c(20, 50, 10) would return 20, 50, and 10 curve points, respectively.  If fixed landmarks are end points of curves,
#' they will not be repeated as additional curve points.  Therefore, one should expect in these cases that the number of semilandmarks
#' are fewer than the number of curve ponits; i.e., choosing 20 curve points might yield 18 semilandmarks.  If left NULL, no curve points
#' will be estimated and only fixed landmarks will be read.
#' @param continuous.curve An optional value or string of values to indicate which curves are closed and whose same start and end
#' point should be treated as a semilandmark.  For example, if one wishes to digitize a curve around an eye, for digitizing purposes a point might
#' be initiated to find a curve around the eye and back to the point.  This point will be "fixed" without indicating the curve is continuous.  One 
#' could use this argument to indicate which curves are continuous; e.g., continuous.curve = c(2, 5) to indicate curves 2 and 5
#' have starting points that are not fixed landmarks but really sliding semilandmarks, as part of a closed curve.
#' @param scaled A logical value (stating whether warnings should be printed (TRUE as default) to indicate whether scaled landmarks and curve
#' points should be used.  If any scales are missing, the function will default to scaled = FALSE.
#' @export
#' @keywords IO
#' @author Michael Collyer
#' @seealso readShapes (from StreoMorph)
#' @return An object of class "geomorphShapes" is a list containing the following
#' \item{landmarks}{A list of specimen by specimen landmarks, arranged with fixed landmarks first and semilandmarks second.}
#' \item{fixed}{A vector indicating which landmarks are initially considered "fixed" (but this can be changed).}
#' \item{sliders}{A vector indicating which landmarks are initially considered semilandmarks, or "sliders".}
#' \item{curves}{A matrix used in gpagen to define how semilandmarks slide by tangents described by flanking points. 
#' Each row of the matrix is a series of three points: tangent point 1, slider, tangent point 2.  This matrix can be edited.
#' to remove sliding points or add some, if points were originally considered fixed.  This matrix is merely a suggestion,
#' based on the curve information read in from a shapes object.  Users should be able to rearrange this matrix, as needed.}
#' \item{n}{The number of specimens.}
#' \item{p}{The number of (both fixed and semi-) landmarks.}
#' \item{k}{The number of landmark dimensions, currently only 2.}
#' \item{scaled}{Logical value to indicate in landmarks are scaled.}
#'   
#' @examples
#' # A true example is not possible, as digitizing experiences are unqiue, but here is a general set-up
#' # myShapes <- readShapes("myDigitizingFile") # data from readShapes from StereoMorph 
#' # myGMdata <- readland.shapes(myShapes) # just reading in the fixed landmarks
#' # myGMdata <- readland.shapes(myShapes, 
#' #      nCurvePts = c(10, 15, 5), 
#' #      continuous.curve = 2) # fixed landmarks plus curve points for three curves, one closed
#' # myGPA <- gpagen(myGMdata, procD = FALSE) # GPA perfomed with minimized bending energy
readland.shapes <- function(Shapes, nCurvePts = NULL, continuous.curve = NULL, scaled = TRUE){
  if(is.null(nCurvePts)) GMfromShapes0(Shapes) else
    GMfromShapes1(Shapes, nCurvePts = nCurvePts, continuous.curve = continuous.curve)
}