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
            System.Threading.Thread.Sleep(3000);
            Assert.True(true);
        }

        [Test, Category("SecondTest")]
        public void Hotel_Add_Ternopol()
        {
            System.Threading.Thread.Sleep(5000);
            Assert.True(true);
        }
    }
}
