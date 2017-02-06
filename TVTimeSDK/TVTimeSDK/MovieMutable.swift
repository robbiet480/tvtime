/******************************************************************************
 *
 * MovieMutable
 *
 ******************************************************************************/

public final class MovieMutable {
    
    //MAR: Public
    public let movie: Movie!
    public var id: String {
        get {
            return movie.id!
        }
    }

    // MARK: Mutable Properties
    var profile: MovieProfile

    public init(movie: Movie, profile: MovieProfile) {

        self.movie = movie
        self.profile = profile
    }
}
