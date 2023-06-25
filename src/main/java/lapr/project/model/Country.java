package lapr.project.model;

public class Country {
    private final String name;
    private final String continent;

    public Country(String name, String continent) {
        this.name = name;
        this.continent = continent;
    }

    public String getName() {
        return name;
    }

    public String getContinent() {
        return continent;
    }

    @Override
    public boolean equals(Object o) {

        if (o == this)
            return true;

        if (!(o instanceof Country))
            return false;

        return this.name.compareTo(((Country) o).name) == 0;
    }

    @Override
    public int hashCode()
    {
        return this.name.hashCode();
    }
}
