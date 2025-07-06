using System;
namespace Library.Utils;

public static class Guard
{
    public static void NotNull<T>(T? value, string parameterName)
        where T : class
    {
        if (value is null)
        {
            throw new ArgumentNullException(parameterName);
        }
    }
}
