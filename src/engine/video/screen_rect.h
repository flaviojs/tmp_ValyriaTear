///////////////////////////////////////////////////////////////////////////////
//            Copyright (C) 2004-2011 by The Allacrost Project
//            Copyright (C) 2012-2016 by Bertram (Valyria Tear)
//                         All Rights Reserved
//
// This code is licensed under the GNU GPL version 2. It is free software
// and you may modify it and/or redistribute it under the terms of this license.
// See http://www.gnu.org/copyleft/gpl.html for details.
///////////////////////////////////////////////////////////////////////////////

/** ****************************************************************************
*** \file    screen_rect.h
*** \author  Raj Sharma, roos@allacrost.org
*** \author  Yohann Ferreira, yohann ferreira orange fr
*** \brief   Header file for the ScreenRect class.
*** The ScreenRect class is used for storing rectangles with pixel coordinates
*** ***************************************************************************/

#ifndef __SCREEN_RECT_HEADER__
#define __SCREEN_RECT_HEADER__

namespace vt_video
{

/** ****************************************************************************
*** \brief A structure used for storing rectangles with pixel coordinates
*** This class is used in storing the current scissoring rectangles, viewport
*** rectangles, etc. It is based on standard screen coordinates, where (0,0)
*** is the top-left and the unit is 1 pixel (hence int32_t coordinates instead of
*** floats)
*** ***************************************************************************/
class ScreenRect
{
public:
    ScreenRect():
        left(0),
        top(0),
        width(0),
        height(0)
    {}

    ScreenRect(int32_t l, int32_t t, int32_t w, int32_t h):
        left(l),
        top(t),
        width(w),
        height(h)
    {}

    void Set(int32_t l, int32_t t, int32_t w, int32_t h)
    { left = l; top = t; width = w; height = h; }


    /** \brief Modifies the rectangle coordinates to be an intersection of itself with another rectangle
    *** \param rect The rectangle to intersect this rectangle with
    *** The resulting intersection rectangle will have all its members set to zero if the two rectangles
    *** do not intersect. If the current rectangle has 100% intersection with the argument rectangle, no
    *** change in coordinates will occur. Typically, the intersection will be a smaller rectangle than
    *** the original two rectangles.
    *** \note This function is defined in video.cpp
    **/
    void Intersect(const ScreenRect &rect) {
        // Find max left and top coordinates
        if(rect.left > left)
            left = rect.left;
        if(rect.top > top)
            top = rect.top;

        // Find min right and bottom coordinates
        int32_t right = left + width - 1;
        int32_t bottom = top + height - 1;
        if(rect.left + rect.width - 1 < right)
            right = rect.left + rect.width - 1;
        if(rect.top + rect.height - 1 < bottom)
            bottom = rect.top + rect.height - 1;

        if(left > right || top > bottom) {
            left = right = width = height = 0;
        } else {
            width = right - left + 1;
            height = bottom - top + 1;
        }
    }

    //! \brief Coordinates for the top left corner of the rectangle
    int32_t left, top;

    //! \brief Stores the dimensions for this rectangle
    int32_t width, height;
}; // class ScreenRect

}  // namespace vt_video

#endif // __SCREEN_RECT_HEADER__
