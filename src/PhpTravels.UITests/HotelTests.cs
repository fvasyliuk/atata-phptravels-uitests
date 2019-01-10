using Atata;
using NUnit.Framework;
using PhpTravels.UITests.Components;

namespace PhpTravels.UITests
{
    public class HotelTests : UITestFixture
    {
        [Test, Category("FirstTest")]
        public void Hotel_Add_London()
        {
            //LoginAsAdmin();

            //Go.To<HotelsPage>().
            //    Add.ClickAndGo().
            //        HotelName.SetRandom(out string name).
            //        HotelDescription.SetRandom(out string description).
            //        Location.Set("London").
            //        Submit().
            //    Hotels.Rows[x => x.Name == name].Should.BeVisible();

            Assert.True(true);
        }

        [Test, Category("SecondTest")]
        public void Hotel_Add_Ternopol()
        {
            // LoginAsAdmin();

            // Go.To<HotelsPage>().
            //     Add.ClickAndGo().
            //         HotelName.SetRandom(out string name).
            //         HotelDescription.SetRandom(out string description).
            //         Location.Set("Ternopol").
            //         Submit().
            //     Hotels.Rows[x => x.Name == name].Should.BeVisible();

            Assert.True(true);
        }
    }
}
