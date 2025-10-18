#include <string.h>

class Location{
private:
    char* city;
    char* country;
public:

    Location(const char* c, const char* co);
    bool same_country(const Location& loc) const;

};
bool Location::same_country(const Location& loc) const {
    return !strcmp(country, loc.country);
}